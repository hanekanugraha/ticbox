<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="ticbox"/>
    <title>Read Message</title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="module">
            <div class="module-header">
                <div class="title">Read Message</div>
            </div>

            <div class="module-content">

                <div style="font-weight: bold; margin-top: 10px;">Read Message</div>

                <g:if test="${flash.message}">
                    <div class="alert alert-success" style="display: block">${flash.message}</div>
                </g:if>

                <g:form name="createMessage" controller="userMessage" action="sendMessage" class="form-horizontal" style="margin: 20px 0 0 0;">
                    <input type="hidden" name="targetUri" value="${targetUri}"/>
                    <input type="hidden" name="toUser" value="${fromUserName}"/>
                    <input type="hidden" name="subjectMessage" value="${subjectMessage}"/>
                    <fieldset>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">From</label>
                            <div class="col-sm-3">
                                ${fromUserName}
                            </div>
                        </div>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">Subject</label>
                            <div class="col-sm-3">
                                ${subjectMessage}
                            </div>
                        </div>
                        <div class="form-group">
                            <label  class="col-sm-2 control-label">Message</label>
                            <div class="col-sm-3">
                                ${contentMessage}
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="contentMessage" class="col-sm-2 control-label">Reply Message</label>
                            <div class="col-sm-3">
                                <textarea class="form-control" rows="5" name="contentMessage" id="contentMessage" placeholder="Subject Message"> </textarea>
                            </div>
                        </div>


                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-3">
                                <button id="submit" class="btn btn-default btn-green">
                                    <span class="glyphicon glyphicon-log-in"></span> Reply
                                </button>

                            </div>
                        </div>
                    </fieldset>
                </g:form>

            </div>

        </div>
    </div>
</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {

        $('input[name="toUser"]').focus();

        $('#submit').click(function() {
            $('#sendMessage').submit();
        });


        $('#createMessage').validate({
            rules: {
//                toUser: {
//                    required: true,
//                    minlength: 3
//                }
            }
        });
    });
</script>
</body>
</html>
