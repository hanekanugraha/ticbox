<html>
<head>
    <meta name="layout" content="respondent"/>
    <title><g:message code="resp.surveylist.label"/> </title>
    <style type="text/css">
        /*.survey-row {*/
            /*margin: 1em 0em;*/
            /*display: flex;*/
            /*display: -webkit-flex;*/
            /*display: -moz-flex;*/
            /*min-width: 100%;*/
        /*}*/

        .survey-img-box {
            float: left;
            background-color: #EFEFEF;
            padding:0.5em;
            width: 14%;
        }

        .survey-content-box {
            float: left;
            background-color: #dddddd;
            padding:0.5em;
            width: 67%;
            position: relative;
            margin-left: 5px;
            margin-right: 5px;
        }

        .survey-nav-box {
            float: right;
            background-color: #EFEFEF;
            padding:0.5em;
            text-align: center;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
        }

        pre {
            margin: 0;
            padding: 0;
            font-family: inherit;
            font-size: inherit;
            color: inherit;
            -webkit-border-radius: 0;
            -moz-border-radius: 0;
            border-radius: 0;

            display: block;
            line-height: inherit;
            word-break: normal;
            word-wrap: normal;
            background-color: inherit;
            border: 0;
            border: 0;
        }
    </style>
</head>
<body>
        <div id="surveyHeader" class="module-header">
            <div class="title"><g:message code="resp.surveylist.label"/></div>
        </div>
        <div id="surveyList" class="module-content">

            <g:if test="${profileRespondent}">
                <div class="module-message"><g:message code="surveylist.please-update-profile.label"/> </div>
            </g:if>
            <g:elseif test="${surveyList}">
                <g:each in="${surveyList}" var="survey">
                    <div class="panel panel-default" style="position: relative">
                        <g:if test="${ticbox.Survey.POINT_TYPE.GOLD.equalsIgnoreCase(survey.pointType)}">
                            <div class="survey-tag survey-tag-gold">
                        </g:if>
                        <g:else>
                            <div class="survey-tag survey-tag-trust">
                        </g:else>
                            ${survey.point} ${survey.pointType}
                    </div>
                        <div class="panel-heading">
                            <div class="media">
                                <a class="pull-left" href="#" style="cursor: default">
                                    <img class="media-object img-circle img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" alt="" style="width: 64px; height: 64px; background: #4f4f4f url('../images/skin/survey-default-icon.png') no-repeat center; background-size: 70% 70%;">
                                </a>
                                <div class="media-body">
                                    <h4 class="media-heading">
                                        ${survey.name}
                                    </h4>
                                    <p>
                                        <g:if test="${survey.title}">
                                            ${survey.title}
                                        </g:if>
                                        <g:else>
                                            <div class="module-message" style="font-size: inherit"><g:message code="surveylist.nodesc.label"/> </div>
                                        </g:else>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="panel-body">
                            <g:link action="takeSurvey" params="[surveyId:survey.surveyId]" class="btn btn-blue-trust btn-xs" style="margin-right: 10px"><g:message code="surveylist.takesurvey.label"/> </g:link>
                            <g:message code="surveylist.respneeded.label"/>: ${survey.ttlRespondent} &nbsp; | &nbsp; <g:message code="app.completion.label"/> : 0%
                        </div>
                        </div>
                    </g:each>
            </g:elseif>
            <g:else>
                <div class="module-message"><g:message code="surveylist.nosurvey.label"/> </div>
            </g:else>
        </div>
</body>
</html>