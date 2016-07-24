package ticbox

import com.mongodb.DBObject
import grails.converters.JSON
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64
import org.bson.types.ObjectId
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.apache.shiro.SecurityUtils
import uk.co.desirableobjects.ajaxuploader.exception.FileUploadException
import java.text.SimpleDateFormat
import pl.touk.excel.export.WebXlsxExporter
import java.io.*;

class SurveyController {

    def surveyService
    def surveyorService

    def index() {
        /*if(!surveyorService.getCurrentSurveyor()){
            flash.message = 'Your profile as surveyor cannot be found'

            redirect uri: '/'
        }*/

        def surveyorProfile = surveyorService.currentSurveyor
        def principal = SecurityUtils.subject.principal
        def surveyor = User.findByUsername(principal.toString())
		def allSurveys = Survey.findAllBySurveyor(surveyorService.currentSurveyor)
		def draftSurveys = allSurveys.findAll{ it.status == Survey.STATUS.DRAFT }
		def inProgressSurveys = allSurveys.findAll{ it.status == Survey.STATUS.IN_PROGRESS }
		def completedSurveys = allSurveys.findAll{ it.status == Survey.STATUS.COMPLETED }
		def submittedSurveys = allSurveys.findAll{ it.status == Survey.STATUS.SUBMITTED }
		
        Survey survey = surveyService.getCurrentEditedSurvey()

        [
            allSurveys : allSurveys,
            drafts : draftSurveys,
            inProgress : inProgressSurveys,
            completes : completedSurveys,
            submitted : submittedSurveys,
            surveyorProfile: surveyorProfile,
            surveyor: surveyor,
            survey: survey,
            countDraft: draftSurveys.size(),
            countInProgress : inProgressSurveys.size(),
            countCompleted : completedSurveys.size(),
            countSubmitted : submittedSurveys.size()
        ]

    }

    def createSurvey(){
        System.out.println("createSurvey");
        surveyService.createSurvey(params)
        clearImages()
        redirect action: 'respondentFilter'
    }

    def editSurvey(){
        System.out.println("createSurvey");
        Survey survey=surveyService.getSurvey(params.surveyId)
        session.putAt('current-edited-survey', survey)

        redirect action: 'respondentFilter'
    }

    def getSurveySummary() {
        def jsonStr = com.mongodb.util.JSON.serialize(surveyService.getCurrentEditedSurvey()[Survey.COMPONENTS.SUMMARY_DETAIL])

        render jsonStr
    }

    def getRespondentFilter() {
        Survey survey = surveyService.getSurvey(surveyService.getCurrentEditedSurvey().surveyId)
		
        def jsonStr = {}
		if(survey)
			jsonStr = com.mongodb.util.JSON.serialize(survey[Survey.COMPONENTS.RESPONDENT_FILTER])

        render jsonStr
    }

    def getQuestionItems(){

        Survey survey = null

        if(params.surveyId){
            survey = surveyService.getSurvey(params.surveyId)
        }else{
            def surveyId = surveyService.getCurrentEditedSurvey().surveyId
            survey = surveyService.getSurvey(surveyId)
        }

        def jsonStr = null

        if (survey) {
            jsonStr = com.mongodb.util.JSON.serialize(survey[Survey.COMPONENTS.QUESTION_ITEMS])
        }

        render jsonStr
    }

    def respondentFilter(){

        Survey survey = surveyService.getCurrentEditedSurvey()

        if(!survey){
            redirect action: 'index'
        }

		survey.title = survey.title?.decodeHTML()?.replace('<br/>', '\\n')

        def surveyorProfile = surveyorService.currentSurveyor
        def principal = SecurityUtils.subject.principal
        def surveyor = User.findByUsername(principal.toString())
		
		def allSurveys = Survey.findAllBySurveyor(surveyorProfile)
		
        [
                survey : survey,
                profileItems : surveyService.profileItemsForRespondentFilter,
                surveyorProfile: surveyorProfile,
                surveyor: surveyor,
                countDraft: allSurveys.findAll{ it.status == Survey.STATUS.DRAFT }.size(),
                countInProgress : allSurveys.findAll{ it.status == Survey.STATUS.IN_PROGRESS }.size(),
                countCompleted : allSurveys.findAll{ it.status == Survey.STATUS.COMPLETED }.size(),
                countSubmitted : allSurveys.findAll{ it.status == Survey.STATUS.SUBMITTED }.size()
        ]
    }

    def submitRespondentFilter() {
        try {
            def filterItemsJSON = params.filterItemsJSON
            Survey survey = surveyService.getSurvey(surveyService.getCurrentEditedSurvey().surveyId)

            String password = params.password
            if (password == 'trivialFakeValue') {
                password = "__unchanged__"
            } else if (password == '') {
                password = null
            }

            if (!survey) {
                survey = surveyService.getCurrentEditedSurvey();
            }

            surveyService.submitRespondentFilter(params.surveyType, params.compDateFrom, params.compDateTo,
                        params.ttlRespondent, password, filterItemsJSON, survey)

            render filterItemsJSON
        } catch (Exception e) {
            e.printStackTrace()
            render 'FAILED'
        }
    }

    def surveyGenerator(){

        def surveyId = surveyService.getCurrentEditedSurvey().surveyId
        Survey survey = surveyService.getSurvey(surveyId)

        if(!survey){
            redirect action: 'index'
        }

        clearImages();

        def surveyorProfile = surveyorService.currentSurveyor
        def principal = SecurityUtils.subject.principal
        def surveyor = User.findByUsername(principal.toString())

		def allSurveys = Survey.findAllBySurveyor(surveyorProfile)
		
        [
                survey : survey,
                surveyorProfile: surveyorProfile,
                surveyor: surveyor,
                countDraft: allSurveys.findAll{ it.status == Survey.STATUS.DRAFT }.size(),
                countInProgress : allSurveys.findAll{ it.status == Survey.STATUS.IN_PROGRESS }.size(),
                countCompleted : allSurveys.findAll{ it.status == Survey.STATUS.COMPLETED }.size(),
                countSubmitted : allSurveys.findAll{ it.status == Survey.STATUS.SUBMITTED }.size()
        ]
    }


    def submitAndFinalizeSurvey(){

        try {
//            params.surveyTitle = params.surveyTitle?.encodeAsHTML().replace('\n', '<br/>')

            def obj = JSON.parse(params.questionItems)
            obj.each {
                System.out.println("it = " + it)
                it.questionStr = it.questionStr?.encodeAsHTML().replace('\n', '<br/>')
                putRealImage(it)

                def answer = it.answerDetails
                if (answer.type == 'CHOICE_SINGLE' || answer.type == 'CHOICE_MULTIPLE') {
                    answer.choiceItems.each {
                       putRealImage(it)
                    }
                }
            }
            params.questionItems = obj.toString()

            def count=surveyService.getCountFreeSurvey()
            def limit=Integer.parseInt(Parameter.findByCode("MAX_FREE_SURVEY_PER_SURVEYOR").value)
            if(count>limit) {
                render 'LIMIT'
                return
            }

            // kucing
            Survey survey = surveyService.getSurvey(surveyService.getCurrentEditedSurvey().surveyId)

            if(!survey) {
                survey = surveyService.getCurrentEditedSurvey()
            }

            if(survey.type==Survey.SURVEY_TYPE.FREE){
                def maxQuestion = Parameter.findByCode("MAX_QUESTION_FREE_SURVEY")
                DBObject dbObject = (DBObject) com.mongodb.util.JSON.parse(params.questionItems)
                if(((List)dbObject).size() > Integer.parseInt(maxQuestion.value))
                    throw new Exception()
            }
            if(survey.type==Survey.SURVEY_TYPE.FREE) {
                survey.status=Survey.STATUS.IN_PROGRESS
                survey.enableStatus=Survey.ENABLE_STATUS.ENABLE
            }
            else {
                survey.status = Survey.STATUS.IN_PROGRESS
                survey.enableStatus = Survey.ENABLE_STATUS.DISABLE
            }

            def date = new Date()
            def sdf = new SimpleDateFormat("MM/dd/yyyy")
            survey.createdDate = sdf.format(date)

            if(survey)
                surveyService.submitSurvey(params, survey)
            else
                surveyService.submitSurvey(params, surveyService.getCurrentEditedSurvey())

            if(survey.type==Survey.SURVEY_TYPE.FREE) {
                def freeLink = createLink(controller:'Home',action: 'takeFreeSurvey',params: [surveyId:survey.surveyId] )
                def freeSurveyPage = createLink(action: 'freeSurveyLink', params: [freeLink: freeLink])

                render freeSurveyPage
            } else
            render 'SUCCESS'
        } catch (Exception e) {
            e.printStackTrace()
            render 'FAILED'
        }
    }

    def putRealImage(it) {
        System.out.println("@putRealImage it = " + it)
        // Load the real image
        if (it.imgFid != null && it.imgFid != "") {
            it.img = retrieveImage(Integer.parseInt(it.imgFid))
        } else {
            it.img = null
        }
        it.imgFid = null
    }

    def submitSurvey(){

        try {
            def count=surveyService.getCountFreeSurvey()
            def limit=Integer.parseInt(Parameter.findByCode("MAX_FREE_SURVEY_PER_SURVEYOR").value)
            if(count>limit) {
                render 'LIMIT'
                return
            }
            Survey survey = surveyService.getSurvey(surveyService.getCurrentEditedSurvey().surveyId)
            if(!survey) {
                survey = surveyService.getCurrentEditedSurvey()
            }

            if(survey.type==Survey.SURVEY_TYPE.FREE){
                def maxQuestion = Parameter.findByCode("MAX_QUESTION_FREE_SURVEY")
                DBObject dbObject = (DBObject) com.mongodb.util.JSON.parse(params.questionItems)
                if(((List)dbObject).size() > Integer.parseInt(maxQuestion.value))
                    throw new Exception()
            }
            if(survey)
                surveyService.submitSurvey(params, survey)
            else
                surveyService.submitSurvey(params, surveyService.getCurrentEditedSurvey())

            render 'SUCCESS'
        } catch (Exception e) {
            e.printStackTrace()
            render 'FAILED'
        }
    }

    def submitToAdmin(){
        Survey survey = surveyService.getSurvey(surveyService.getCurrentEditedSurvey().surveyId)

        if(survey) {
//            surveyService.submitSurvey(params, survey)
            surveyService.submitToAdmin(survey)

        }

        if(survey.type==Survey.SURVEY_TYPE.FREE){
            redirect  action: 'freeSurveyLink' , params: [freeLink:createLink(controller:'Home',action: 'takeFreeSurvey',params: [surveyId:survey.surveyId] )]
        }

        else
            redirect   action: 'index'
    }

    def finalizeAndPublishSurvey(){
        try {
            surveyService.finalizeAndPublishSurvey(params, surveyService.getCurrentEditedSurvey())
        }catch (Exception e){
            flash.message = e.message
        }
        redirect action: 'index'
    }

    def getLogoIds(){
        def ids = UserResource.findAllByUserAndKind(surveyorService.getCurrentSurveyor()?.userAccount, Survey.COMPONENTS.LOGO)?.collect {
            it.id.toStringMongod()
        }

        render ids as JSON
    }

    def getResourceIds(){
        def ids = UserResource.findAllByUserAndKind(surveyorService.getCurrentSurveyor()?.userAccount, params.resType)?.collect {
            it.id.toStringMongod()
        }

        render ids as JSON
    }

    def uploadLogo(){

        def rend = [:]
        try {
            def inputStream
            if (request instanceof MultipartHttpServletRequest) {
                MultipartFile multipartFile = ((MultipartHttpServletRequest) request).getFile("qqfile")
                inputStream = multipartFile.inputStream
            } else {
                inputStream = request.inputStream
            }

            def resType = params.resType

            def userResource = new UserResource(user: surveyorService.getCurrentSurveyor()?.userAccount, kind: resType).save()
            userResource[resType] = Base64.encode(inputStream.bytes)
            userResource.save()

            if (userResource.hasErrors()) {
                throw new Exception("${userResource.errors.allErrors.first()}")
            }

            rend.success = true
            rend.resourceId = userResource.id.toStringMongod()

        } catch (Exception e) {
            rend.success = false
            rend.message = "Failed to save logo"
            log.error("${e.class}, ${e.message?:e.cause.message}")
        }

        render rend as JSON

    }
    
    def viewLogo() {
        def userResource

        if (params.resourceId) {
            userResource = UserResource.findById(new ObjectId(params.resourceId))
        }else{
            def survey = surveyService.getCurrentEditedSurvey()

            if (survey) {
                ObjectId objectId = survey[Survey.COMPONENTS.LOGO]
                userResource = UserResource.findByid(objectId)
            }
        }

        if (userResource) {
            def imageByte = Base64.decode(userResource[Survey.COMPONENTS.LOGO])
            response.outputStream << imageByte
        }
    }

    def viewResources() {
        def userResource

        if (params.resourceId) {
            userResource = UserResource.findById(new ObjectId(params.resourceId))
        }

        if (userResource) {
            def imageByte = Base64.decode(userResource[params.resType])
            response.outputStream << imageByte
        }
    }

    def getSurveyResult(){
        def result = surveyService.getSurveyResult(params.surveyId)
        if (result==null)
            System.out.println('result null!')
        else
            System.out.println(result as JSON)
        render result as JSON
    }

	def downloadSurveyResult(){	
	   def result = surveyService.getSurveyRawResult(params.surveyId)
		log.debug(result)
		new WebXlsxExporter().with {
		    setResponseHeaders(response)
			if(result){
				result.eachWithIndex { item,index ,indexPlusOne = index + 1->
				    fillRow(item, indexPlusOne)
				}
			}
		    save(response.outputStream)
		}
	}

    def deleteSurvey(){
        surveyService.deleteSurvey(params)

        redirect action: 'index'
    }

    def freeSurveyLink={
        [freeLink: params.freeLink]
    }

    def profileForm() {
		def surveyorProfile = surveyorService.currentSurveyor
        def profileItems = surveyService.getSurveyorProfileItems()
        def principal = SecurityUtils.subject.principal
        def surveyor = User.findByUsername(principal.toString())
        def surveyorDetail = SurveyorDetail.findBySurveyorId(surveyor.id)
		def allSurveys = Survey.findAllBySurveyor(surveyorProfile)
        surveyorDetail = surveyorDetail ?: new SurveyorDetail(surveyorId: surveyor.id).save()
        [profileItems: profileItems,surveyor: surveyor, surveyorDetail: surveyorDetail,
                            countDraft:allSurveys.findAll{ it.status == Survey.STATUS.DRAFT }.size(),
                            countInProgress:allSurveys.findAll{ it.status == Survey.STATUS.IN_PROGRESS }.size(),
                            countCompleted:allSurveys.findAll{ it.status == Survey.STATUS.COMPLETED }.size(),
                            countSubmitted:allSurveys.findAll{ it.status == Survey.STATUS.SUBMITTED }.size()]
    }

    def modify = {
        def surveyor = User.findById(params.id)
        surveyor.email = params.email
        surveyor.save()

        forward(action: "index")
    }

    def uploadImage = {
        def message
        try {
            def inputStream
            if (request instanceof MultipartHttpServletRequest) {
                MultipartFile multipartFile = ((MultipartHttpServletRequest) request).getFile("qqfile")
                inputStream = multipartFile.inputStream
            } else {
                inputStream = request.inputStream
            }

            // update user
            def user = User.findById(params.surveyorId)
            user.pic = Base64.encode(inputStream.bytes)
            user.save()

            if (user.hasErrors()) {
                throw new Exception(user.errors.allErrors.first())
            }

            return render(text: [success:true, img:user.pic] as JSON, contentType:'text/json')
        } catch (FileUploadException e) {
            message = "Failed to upload file."
            log.error(message, e)
        } catch (Exception e) {
            message = "Failed to save surveyor"
            log.error(message, e)
        }
        return render(text: [success:false, message: message] as JSON, contentType:'text/json')
    }

    def uploadImageToString = {
        def message
        try {
            def inputStream
            if (request instanceof MultipartHttpServletRequest) {
                MultipartFile multipartFile = ((MultipartHttpServletRequest) request).getFile("qqfile")
                inputStream = multipartFile.inputStream
            } else {
                inputStream = request.inputStream
            }

            String pic = Base64.encode(inputStream.bytes)
            int tempFileId = storeImage(pic)

            return render(text: [success:true, img:pic, fid:tempFileId] as JSON, contentType:'text/json')
        } catch (FileUploadException e) {
            message = "Failed to upload file."
            log.error(message, e)
        } catch (Exception e) {
            message = "Unknown error"
            log.error(message, e)
        }
        return render(text: [success:false, message: message] as JSON, contentType:'text/json')
    }

    static String CREATING_SURVEY_IMAGES_SESSION_KEY = 'making-of-survey.images'

    /**
     * Save an image to be called back later
     * @Return a unique identifier for this image
     */
    int storeImage(String base64Picture) {
        List<String> images = session[CREATING_SURVEY_IMAGES_SESSION_KEY]
        if (images == null) {
            images = new ArrayList<String>()
            session[CREATING_SURVEY_IMAGES_SESSION_KEY] = images
        }
        images.add(base64Picture)

        return images.size() - 1;
    }

    String retrieveImage(int id) {
        List<String> images = session[CREATING_SURVEY_IMAGES_SESSION_KEY]
        if (images != null && images.size() > id) {
            return images.get(id);
        } else {
            return null;
        }
    }

    List<String> clearImages() {
        List<String> images = session[CREATING_SURVEY_IMAGES_SESSION_KEY]
        session[CREATING_SURVEY_IMAGES_SESSION_KEY] = null
        return images
    }

    def viewImage = {
        def user = User.findById(params.surveyorId)
        def imageByte
        if (user?.pic) {
            imageByte = Base64.decode(user?.pic)
        }
        response.outputStream << imageByte
    }
}
