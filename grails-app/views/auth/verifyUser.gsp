<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="ticbox"/>
    <title><g:message code="ticbox.verify.title"/></title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="module">
            <div class="module-header">
                <div class="title"><g:message code="ticbox.verify.title"/></div>
            </div>

            <div class="module-content">

                <div style="font-weight: bold; margin-top: 10px;"><g:message code="ticbox.verify.content"/></div>

                <g:if test="${flash.message}">
                    <div class="alert alert-success" style="display: block">${flash.message}</div>
                </g:if>

                <g:form name="verifyUser" action="verifyCode" class="form-horizontal" style="margin: 20px 0 0 0;">
                    <input type="hidden" name="targetUri" value="${targetUri}"/>

                    <div class="form-group">
                        <label for="verifyCode" class="col-sm-2 control-label"><g:message code="ticbox.verify.verifycode"/></label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" name="verifyCode" id="verifyCode" value="${verifyCode}" placeholder="Verify Code"/>
                        </div>
                    </div>



                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-3">
                            <button id="submit" class="btn btn-default btn-green">
                                <span class="glyphicon glyphicon-log-in"></span> <g:message code="label.button.verify"/>
                            </button>
                        </div>
                    </div>
                </g:form>

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
