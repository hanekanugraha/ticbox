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

                        <div style="position: absolute; margin-top: 10px; right:7px">
                            <g:if test="${survey.passwordHash}">
                                <img class="img-responsive" title="This is a protected survey that requires password to take it" src="${request.contextPath}/images/ticbox/lock-25x25.png" />
                            </g:if>
                        </div>
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
                            <g:if test="${survey.passwordHash}">
                                <a href="#take-protected-survey" data-toggle="modal" class="btn btn-blue-trust btn-xs" style="margin-right: 10px">
                                    <g:message code="surveylist.takesurvey.label"/>
                                </a>
                            </g:if>
                            <g:else>
                                <g:link action="takeSurvey" params="[surveyId:survey.surveyId]" class="btn btn-blue-trust btn-xs" style="margin-right: 10px">
                                    <g:message code="surveylist.takesurvey.label"/>
                                </g:link>
                            </g:else>
                            <g:message code="surveylist.respneeded.label"/>: ${survey.ttlRespondent} &nbsp; | &nbsp; <g:message code="app.completion.label"/> : 0%
                        </div>
                        </div>
                    </g:each>
            </g:elseif>
            <g:else>
                <div class="module-message"><g:message code="surveylist.nosurvey.label"/> </div>
            </g:else>
        </div>


        <!-- Change password modal -->
        <div id="take-protected-survey" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                        <span id="myModalLabel" class="modal-title" >Password required</span>
                    </div>
                    <g:form name="takeProtectedSurveyForm" class="form-horizontal" role="form">
                        <div class="modal-body form-horizontal">
                            <p>
                            You are required to enter password to access this survey
                            </p>
                            <div class="form-group">
                                <label for="oldPassword" class="col-xs-4 control-label">
                                    <g:message code="app.password.label"/>
                                </label>
                                <div class="col-xs-7">
                                    <g:hiddenField name="id" value="${respondent.id}" />
                                    <g:passwordField id="oldPassword" class="form-control" name="oldPassword" />
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button id="take-protected-survey-button" class="btn btn-default btn-green">
                                Unlock
                            </button>
                        </div>
                    </g:form>
                </div>
                <!-- End of "class=modal-content" -->

            </div>
            <!-- End of "class=modal-dialog" -->

        </div>

    <g:javascript src="jquery.validate.min.js"/>
    <g:javascript src="additional-methods.min.js"/>
    <script type="text/javascript">

    /* Change password modal trigger */
    $("#take-protected-survey-button").click(function(e) {
        var form = $('#takeProtectedSurveyForm');
        if (form.valid()) {
            var url = '${g.createLink(controller: "auth", action: "changePassword")}';
            var data = $("#take-protected-survey-model").find("input").serialize();
            $.post(url, data, function(response) {
                var message = (response) ? response.message : "Application error";
                $('#change-password-modal').modal('hide');
                flashMessage(message, response.success);

                if (message = "success") {
                    window.location = "${request.contextPath}/survey/surveyGenerator";

    }
            });
    } else {
    $(this).button('reset');
    }
    e.preventDefault();
    return false;
    });
    </script>
    </body>
</html>