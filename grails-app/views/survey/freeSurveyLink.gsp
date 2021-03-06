<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="ticbox"/>
    <title><g:message code="survey.freesurveylink.label"/></title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="module">
            <div class="module-header">
                <div class="title"><g:message code="survey.freesurveylink.label"/></div>
            </div>

            <div class="module-content">

                <div style="font-weight: bold; margin-top: 10px;"><g:message code="survey.freesurveylink.label"/> <a href="${freeLink}">${freeLink}</a></div>

                <g:if test="${flash.message}">
                    <div class="alert alert-success" style="display: block">${flash.message}</div>
                </g:if>



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
