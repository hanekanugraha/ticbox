package ticbox

class Survey {
    static SURVEY_TYPE = [EASY:"EASY", FREE:"FREE"]
    static POINT_TYPE = [TRUST:"TRUST", GOLD:"GOLD"]
    static STATUS = [DRAFT:'DRAFT', IN_PROGRESS:'IN_PROGRESS', COMPLETED:'COMPLETED', SUBMITTED:'SUBMITTED']
    static ENABLE_STATUS = [ENABLE:'ENABLED', DISABLE:'DISABLED']

    static QUESTION_TYPE = [
        CHOICE_SINGLE : 'CHOICE_SINGLE',
        CHOICE_MULTIPLE : 'CHOICE_MULTIPLE',
        FREE_TEXT : 'FREE_TEXT',
        SCALE_RATING : 'SCALE_RATING',
        STAR_RATING : 'STAR_RATING'
    ]

    static COMPONENTS = [
        SUMMARY_DETAIL : 'SUMMARY_DETAIL',
        RESPONDENT_FILTER : 'RESPONDENT_FILTER',
        QUESTION_ITEMS : 'QUESTION_ITEMS',
        LOGO : 'LOGO'
    ]

    String id
    String surveyId
    String name
    String title
    long point = 0
    String pointType = POINT_TYPE.GOLD
    String status = STATUS.DRAFT
    String type = SURVEY_TYPE.EASY
    String enableStatus = ENABLE_STATUS.ENABLE
    static belongsTo = [surveyor:SurveyorProfile]

    static constraints = {
        title maxSize: 1000, nullable: true
		completionDateFrom nullable: true
		completionDateTo nullable: true
		surveyor nullable: true
		modifiedDate nullable: true
    }

    String completionDateFrom
    String completionDateTo
    long ttlRespondent
    long surveyPrice
    String createdDate
	String modifiedDate

}
