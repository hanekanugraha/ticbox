<html>
<head>
    <meta name="layout" content="ticbox"/>
    <title>Verify User success</title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="module">
            <div class="module-header">
                <div class="title">Account Verification Complete!</div>
            </div>

            <div class="module-content">

                %{--<div style="font-weight: bold; margin-top: 10px;">Verify User success</div>--}%

                %{--<g:if test="${flash.message}">--}%
                    %{--<div class="alert alert-success" style="display: block">${flash.message}</div>--}%
                %{--</g:if>--}%

                <div class="well well-lg">
                    <g:if test="${request.getSession().getAttribute("role") == Role.ROLE.SURVEYOR}">
                        <g:message code="auth.verify.success.surveyor"/>
                    </g:if>
                    <g:elseif test="${request.getSession().getAttribute("role") == Role.ROLE.RESPONDENT}">
                        <g:message code="auth.verify.success.respondent"/>
                    </g:elseif>
                    <g:else>
                        <g:message code="auth.verify.success.default"/>
                    </g:else>
                </div>

            </div>


        </div>
    </div>
</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {

        $('input[name="verifyUser"]').focus();

        $('#submit').click(function() {
            $('#verifyCode').submit();
        });

        $('#verifyUser').validate({
            rules: {
                verifyCode: {
                    required: true,
                    minlength: 9
                }
            }
        });
    });
</script>
</body>
</html>
