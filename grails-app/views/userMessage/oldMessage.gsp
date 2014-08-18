<%@ page import="ticbox.User; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="ticbox"/>
    <title>Old Message</title>
    <style type="text/css">

    </style>
</head>
<body>
<div class="module">
    <div id="adminHeader" class="module-header">
        <div class="title">Old Message</div>
    </div>
    <div id="messageList" class="module-content">
        <div class="row" style="margin-bottom:10px">
            <div class="col-sm-12">
                <g:link controller="userMessage" action="createMessage" role="button" class="btn btn-primary" > New Message</g:link>
                <a id="delMessage" href="#delete-messages-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Delete</a>

            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <table id="messageTable" class="table table-bordered table-striped table-hover">
                    <thead>
                    <tr>
                        <th></th>
                        <th>From</th>
                        <th>Subject</th>
                        <th>is Read</th>

                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${userMessages}" var="userMessage" >
                        <tr>
                            <td><input type="checkbox" name="usermessageIds" value="${userMessage.id}" /></td>
                            <td>${userMessage.fromUsername}</td>
                            <td><g:link controller="userMessage" action="readMessage" title="${userMessage.subject}" params="[code: userMessage.id]">${userMessage.subject}</g:link></td>
                            <td>${userMessage.isRead}</td>

                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<!-- Delete users modal -->
<div id="delete-messages-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="deleteMessagesLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="deleteMessagesLabel" class="modal-title">
                    Delete Message
                </span>
            </div>
            <div class="modal-body">
                <g:form name="deleteMessageForm" controller="userMessage" action="deleteMessages" role="form">
                    <input type="hidden" id="delMessageIds" name="delMessageIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to delete these messages?</b></p>
                        There is no rollback for deleted messages. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="deleteMessages" class="btn btn-danger" data-loading-text="Processing..">Delete</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>
    </div>
</div>



<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {


        /* Delete users */
        $('#deleteMessages').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#deleteMessageForm');
            $('input[name=usermessageIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#delMessageIds', form).val(selected);
            form.submit();
        });



        // Validations
        $('#addNewUserForm').validate({
            rules: {
                userType: {
                    required: true
                },
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