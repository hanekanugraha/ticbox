<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="layout" content="ticbox"/>
    <title>Create Message</title>
</head>

<body>
<div class="row">
    <div class="col-md-12">
        <div class="module">
            <div class="module-header">
                <div class="title">Create Message</div>
            </div>

            <div class="module-content">

                <div style="font-weight: bold; margin-top: 10px;">Write New Message</div>

                <g:if test="${flash.message}">
                    <div class="alert alert-success" style="display: block">${flash.message}</div>
                </g:if>

                <g:form name="createMessage" controller="userMessage" action="sendMessage" class="form-horizontal" style="margin: 20px 0 0 0;">
                    <input type="hidden" name="targetUri" value="${targetUri}"/>
                    <input type="hidden" name="username" value="${username}"/>
                    <fieldset>
                        <div class="form-group">
                            <label for="toUser" class="col-sm-2 control-label">To</label>
                            <div class="col-sm-3">
                                <input type="text" class="form-control" name="toUser" id="toUser" value="${toUser}" placeholder="To User"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="subjectMessage" class="col-sm-2 control-label">Subject</label>
                            <div class="col-sm-3">
                                <input type="text" class="form-control" name="subjectMessage" id="subjectMessage" value="${subjectMessage}" placeholder="Subject Message"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="contentMessage" class="col-sm-2 control-label">Message</label>
                            <div class="col-sm-3">
                                <textarea class="form-control" rows="5" name="contentMessage" id="contentMessage" value="${contentMessage}" placeholder="Subject Message"> </textarea>
                            </div>
                        </div>


                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-3">
                                <button id="submit" class="btn btn-default btn-green">
                                    <span class="glyphicon glyphicon-log-in"></span> Send
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
                toUser: {
                    required: true,
                    minlength: 3
                }
            }
        });
    });
</script>
</body>
</html>
