<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="ticbox"/>
    <title>Forgot Password</title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="module">
            <div class="module-header">
                <div class="title">Forgot Password</div>
            </div>

            <div class="module-content">

                <div style="font-weight: bold; margin-top: 10px;">Please input email</div>

                <g:if test="${flash.message}">
                    <div class="alert alert-success" style="display: block">${flash.message}</div>
                </g:if>

                <g:form name="forgotPassword" action="blastForgotPassword" class="form-horizontal" style="margin: 20px 0 0 0;">
                    <input type="hidden" name="targetUri" value="${targetUri}"/>

                    <div class="form-group">
                        <label for="email" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" name="email" id="email" value="${email}" placeholder="Email"/>
                        </div>
                    </div>



                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-3">
                            <button id="submit" class="btn btn-default btn-green">
                                <span class="glyphicon glyphicon-log-in"></span> Reset
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

        $('input[name="forgotPassword"]').focus();

        $('#submit').click(function() {
            $('#forgotPassword').submit();
        });

        $('#forgotPassword').validate({
            rules: {
                email: {
                    email: true,
                    required: true,
                    minlength: 5
                }
            }
        });
    });
</script>
</body>
</html>
