package ticbox

import com.mongodb.DBObject
import grails.converters.JSON
import com.sun.org.apache.xerces.internal.impl.dv.util.Base64
import org.bson.types.ObjectId
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.multipart.MultipartHttpServletRequest
import org.apache.shiro.SecurityUtils
import uk.co.desirableobjects.ajaxuploader.exception.FileUploadException

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

        Survey survey = surveyService.getCurrentEditedSurvey()

        [
            drafts : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.DRAFT),
            inProgress : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.IN_PROGRESS),
            completes : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.COMPLETED),
            submitted : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.SUBMITTED),
            surveyorProfile: surveyorProfile,
            surveyor: surveyor,
            survey: survey,
            countDraft:Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.DRAFT).size(),
            countInProgress : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.IN_PROGRESS).size(),
            countCompleted : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.COMPLETED).size(),
            countSubmitted : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.SUBMITTED).size()
        ]

    }

    def createSurvey(){

        surveyService.createSurvey(params)

        redirect action: 'respondentFilter'
    }

    def editSurvey(){
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

        def jsonStr = com.mongodb.util.JSON.serialize(survey[Survey.COMPONENTS.RESPONDENT_FILTER])

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

        def surveyorProfile = surveyorService.currentSurveyor
        def principal = SecurityUtils.subject.principal
        def surveyor = User.findByUsername(principal.toString())

        [
                survey : survey,
                profileItems : surveyService.profileItemsForRespondentFilter,
                surveyorProfile: surveyorProfile,
                surveyor: surveyor,
                countDraft:Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.DRAFT).size(),
                countInProgress : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.IN_PROGRESS).size(),
                countCompleted : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.COMPLETED).size(),
                countSubmitted : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.SUBMITTED).size()
        ]
    }

    def submitRespondentFilter() {
        try {
            def filterItemsJSON = params.filterItemsJSON
            Survey survey = surveyService.getSurvey(surveyService.getCurrentEditedSurvey().surveyId)

            if(survey)
                surveyService.submitRespondentFilter(params.surveyType, params.compDateFrom, params.compDateTo, params.ttlRespondent, filterItemsJSON, survey)
            else
                surveyService.submitRespondentFilter(params.surveyType, params.compDateFrom, params.compDateTo, params.ttlRespondent, filterItemsJSON, surveyService.getCurrentEditedSurvey())

            render filterItemsJSON
        } catch (Exception e) {
            e.printStackTrace()
            render 'FAILED'
        }
    }

    def surveyGenerator(){
        Survey survey = surveyService.getCurrentEditedSurvey()

        if(!survey){
            redirect action: 'index'
        }

        def surveyorProfile = surveyorService.currentSurveyor
        def principal = SecurityUtils.subject.principal
        def surveyor = User.findByUsername(principal.toString())

        [
                survey : survey,
                surveyorProfile: surveyorProfile,
                surveyor: surveyor,
                countDraft:Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.DRAFT).size(),
                countInProgress : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.IN_PROGRESS).size(),
                countCompleted : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.COMPLETED).size(),
                countSubmitted : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.SUBMITTED).size()
        ]
    }


    def submitAndFinalizeSurvey(){
        try {
            def count=surveyService.getCountFreeSurvey()
            def limit=Integer.parseInt(Parameter.findByCode("MAX_FREE_SURVEY_PER_SURVEYOR").value)
            if(count>limit) {
                render 'LIMIT'
                return
            }
            Survey survey = surveyService.getSurvey(surveyService.getCurrentEditedSurvey().surveyId)
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


    def submitSurvey(){
        try {
            def count=surveyService.getCountFreeSurvey()
            def limit=Integer.parseInt(Parameter.findByCode("MAX_FREE_SURVEY_PER_SURVEYOR").value)
            if(count>limit) {
                render 'LIMIT'
                return
            }
            Survey survey = surveyService.getSurvey(surveyService.getCurrentEditedSurvey().surveyId)
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

            def userResource = new UserResource(user: surveyorService.getCurrentSurveyor()?.userAccount, kind: Survey.COMPONENTS.LOGO).save()
            userResource[Survey.COMPONENTS.LOGO] = Base64.encode(inputStream.bytes)
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

    def getSurveyResult(){
        def result = surveyService.getSurveyResult(params.surveyId)

        render result as JSON
    }

    def deleteSurvey(){
        surveyService.deleteSurvey(params)

        redirect action: 'index'
    }

    def freeSurveyLink={
        [freeLink: params.freeLink]
    }

    def profileForm() {
        def profileItems = surveyService.getSurveyorProfileItems()
        def principal = SecurityUtils.subject.principal
        def surveyor = User.findByUsername(principal.toString())
        def surveyorDetail = SurveyorDetail.findBySurveyorId(surveyor.id)
        surveyorDetail = surveyorDetail ?: new SurveyorDetail(surveyorId: surveyor.id).save()
        [profileItems: profileItems,surveyor: surveyor, surveyorDetail: surveyorDetail,
                            countDraft:Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.DRAFT).size(),
                            countInProgress : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.IN_PROGRESS).size(),
                            countCompleted : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.COMPLETED).size(),
                            countSubmitted : Survey.findAllBySurveyorAndStatus(surveyorService.currentSurveyor, Survey.STATUS.SUBMITTED).size()]
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

            return render(text: [success:true] as JSON, contentType:'text/json')
        } catch (FileUploadException e) {
            message = "Failed to upload file."
            log.error(message, e)
        } catch (Exception e) {
            message = "Failed to save surveyor"
            log.error(message, e)
        }
        return render(text: [success:false, message: message] as JSON, contentType:'text/json')
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
