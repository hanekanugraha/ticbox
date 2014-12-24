<%@ page contentType="text/html;charset=UTF-8" %>
<html>

<!-- HEADER -->
<head>
    <meta name="layout" content="ticbox"/>
    <title><g:message code="app.register.respondent.label" /></title>
</head>

<!-- BODY -->
<body>
    <div class="module">
        <!-- Header -->
        <div class="module-header">
            <div class="title"><g:message code="app.register.respondent.label" /></div>
        </div>
        <!-- Content -->
        <div class="module-content">
            <g:form name="registerForm" action="register" class="form-horizontal" role="form">
                <g:hiddenField name="userType" value="respondent"/>
                <g:hiddenField name="referrer" value="${ref}"/>

            <fieldset>
                <div class="form-group">
                    <label for="username" class="col-sm-3 control-label"><g:message code="app.username.label"/></label>
                    <div class="col-sm-4"><g:textField name="username" value="${username}" class="form-control"/></div>
                </div>
                <div class="form-group">
                    <label for="email" class="col-sm-3 control-label"><g:message code="app.email.label"/></label>
                    <div class="col-sm-4"><g:textField name="email" value="${email}" class="form-control"/></div>
                </div>
                <div class="form-group">
                    <label for="password" class="col-sm-3 control-label"><g:message code="app.password.label"/></label>
                    <div class="col-sm-4"><g:passwordField name="password" class="form-control"/></div>
                </div>
                <div class="form-group">
                    <label for="passwordconfirm" class="col-sm-3 control-label"><g:message code="app.passwordconfirm.label"/></label>
                    <div class="col-sm-4"><g:passwordField name="passwordconfirm" class="form-control"/></div>
                </div>

                <!-- Captcha -->
                <div class="form-group">
                    <div class="col-sm-8 col-sm-offset-3">
                        <script type="text/javascript"
                                src="https://www.google.com/recaptcha/api/challenge?k=6LcX7_0SAAAAAENhL5WPKwRbZPi7UusrWcCr_fUp">
                        </script>

                        <noscript>
                            <iframe src="https://www.google.com/recaptcha/api/noscript?k=6LcX7_0SAAAAAENhL5WPKwRbZPi7UusrWcCr_fUp"
                                    height="300" width="500" frameborder="0"></iframe><br>
                            <textarea name="recaptcha_challenge_field" rows="3" cols="40">
                            </textarea>
                            <input type="hidden" name="recaptcha_response_field"
                                   value="manual_challenge">
                        </noscript>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-8 col-sm-offset-3"><p class="muted"><g:message code="app.register.disclaimer.message" args="${[request.getContextPath()]}"/></p></div>
                </div>

                <!-- Button -->
                <div class="form-group">
                    <div class="col-sm-8 col-sm-offset-3">
                        <p>
                            <g:submitButton name="submit" value="${g.message(code:'app.register.label')}" class="btn btn-lg btn-green"/>
                            <button type="reset" name="reset" class="btn btn-lg btn-light-oak">${g.message(code:'app.reset.label')}</button>
                        </p>
                    </div>
                </div>

                <!-- Messages -->
                <div class="form-group">
                    <div class="col-sm-12"><h3><g:message code="app.register.sso.message"/></h3></div>
                </div>

                <!-- SocialMedia -->
                <div class="form-group">
                    <div class="col-sm-12">
                        <oauth:connect provider="facebook"><g:img file="ticbox/facebook-signup-button.png"/></oauth:connect>
                        <oauth:connect provider="twitter"><g:img file="ticbox/twitter-signup-button.png"/></oauth:connect>
                        <oauth:connect provider="google"><g:img file="ticbox/google-signup-button.png"/></oauth:connect>
                    </div>
                </div>
            </fieldset>
            </g:form>
        </div>
    </div>

    <!-- Javascript -->
    <g:javascript src="jquery.validate.min.js"/>
    <g:javascript src="additional-methods.min.js"/>
    <script type="text/javascript">
        $(document).ready(function() {

            $('#registerForm').validate({
                rules: {
                    username: {
                        required: true,
                        minlength: 5
                    },
                    email: {
                        email: true,
                        required: true,
                        minlength: 5
                    },
                    password: {
                        required: true,
                        minlength: 5
                    },
                    passwordconfirm: {
                        required: true,
                        minlength: 5,
                        equalTo: password
                    }
                }
            });

        });

    </script>
</body>

</html>