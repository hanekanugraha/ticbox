<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="ticbox"/>
        <title><g:message code="label.login.title"/></title>
    </head>

    <body>
        <div class="row">
            <div class="col-md-12">
                <div class="module">
                    <div class="module-header">
                        <div class="title"><g:message code="label.login.title"/></div>
                    </div>

                    <div class="module-content">

                        <div style="font-weight: bold; margin-top: 10px;"><g:message code="label.login.content1"/></div>

                        %{--<g:if test="${flash.message}">--}%
                            %{--<div class="alert alert-success" style="display: block">${flash.message}</div>--}%
                        %{--</g:if>--}%

                        <g:form name="signIn" action="signIn" class="form-horizontal" style="margin: 20px 0 0 0;">
                            <input type="hidden" name="targetUri" value="${targetUri}"/>

                            <div class="form-group">
                                <label for="username" class="col-sm-2 control-label"><g:message code="app.username.label"/></label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" name="username" id="username" value="${username}" placeholder="Username"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="password" class="col-sm-2 control-label"><g:message code="app.password.label"/></label>
                                <div class="col-sm-4">
                                    <input type="password" class="form-control" name="password" id="password" value="" placeholder="Password"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-4">
                                    <div class="checkbox">
                                        <label>
                                            <g:checkBox name="rememberMe" id="rememberMe" value="${rememberMe}"/>
                                            ${g.message(code: "app.rememberMe.label")}
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-4">
                                    <button style="margin:0 0 5px 0" id="submit" class="btn btn-default btn-green">
                                        <span class="glyphicon glyphicon-log-in"></span> <g:message code="label.button.signin"/>
                                    </button>
                                    <a style="margin:0 0 5px 0" id="forgotPassword" class="btn btn-default btn-coffee" href="${request.contextPath}/home/forgotPassword">
                                        <span class="glyphicon glyphicon-question-sign" ></span> <g:message code="label.button.forgotpassword"/>
                                    </a>
                                </div>
                            </div>
                        </g:form>
                        %{--<a id="forgotPassword" class="btn btn-default btn-green" href="${request.contextPath}/home/forgotPassword">--}%
                            %{--<span class="glyphicon glyphicon-log-in" ></span> Forgot Password--}%
                        %{--</a>--}%
                    </div>

                    <div class="module-header"></div>
                    <div class="module-content">
                        <div style="font-weight: bold; margin-top: 10px;"><g:message code="label.login.content2"/></div>
                        <div class="row" style="margin: 15px 0;">
                            <div class="col-sm-12" style="padding-left: 0">
                                <a style="margin:0 0 5px 0" class="btn btn-lg btn-light-oak" href="${g.createLink(controller: 'auth', action: 'registerRespondent')}">
                                    <span class="glyphicon glyphicon-user"></span> <g:message code="app.register.respondent.label"/>
                                </a>
                                <a style="margin:0 0 5px 0" class="btn btn-lg btn-blue-trust" href="${g.createLink(controller: 'auth', action: 'registerSurveyor')}">
                                    <span class="glyphicon glyphicon-user"></span> <g:message code="app.register.surveyor.label"/>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <g:javascript src="jquery.validate.min.js"/>
        <g:javascript src="additional-methods.min.js"/>
        <script type="text/javascript">
            $(document).ready(function() {

                $('input[name="username"]').focus();

                $('#submit').click(function() {
                    $('#signIn').submit();
                });

                $('#signIn').validate({
                    rules: {
                        username: {
                            required: true,
                            minlength: 5
                        },
                        password: {
                            required: true,
                            minlength: 5
                        }
                    }
                });
            });
        </script>
    </body>
</html>
