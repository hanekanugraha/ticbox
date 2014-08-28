<%@ page import="ticbox.Role; ticbox.Email; ticbox.User; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title>Administrator Page : Emails</title>
    <style type="text/css">

    </style>
</head>
<body>
    <div class="module">
        <div id="adminHeader" class="module-header">
            <div class="title">Emails</div>
        </div>
        <div id="userList" class="module-content">
            <div class="row" style="margin-bottom:10px">
                <div class="col-sm-12">
                    <a id="addEmail" href="#add-new-email-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> New Email</a>
                    <a id="delEmails" href="#delete-email-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Delete</a>

                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <table id="emailTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th></th>
                                <th>Subject</th>
                                <th>Send On</th>
                                <th>Send By</th>

                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${emails}" var="email">
                                <tr>
                                    <td><input type="checkbox" name="emailIds"  value="${email.id}" /></td>
                                    <td>${email.subject}</td>
                                    <td>${email.sendOn}</td>
                                    <td>${email.sendBy}</td>

                                </tr>
                            </g:each>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>

<!-- Add new user modal -->
<div id="add-new-email-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="addNewEmailLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="addNewEmailLabel" class="modal-title">
                    Add New Email
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <g:form name="addNewEmailForm" controller="email" action="createEmail" class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="sendInto" class="col-xs-4 control-label"><g:message code="app.sendTarget.label"/></label>
                        <div class="col" >
                            <input class="item-check" type="checkbox" checked style="height: 34px" name="sendInto" value="${Email.SEND_TARGET.INBOX}"/>User Inbox
                            <input class="item-check" type="checkbox" checked style="height: 34px" name="sendInto" value="${Email.SEND_TARGET.EMAIL}"/>User Email

                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userStatus" class="col-xs-4 control-label"><g:message code="app.userStatus.label"/></label>
                        <div class="col" >
                            <input class="item-check" type="checkbox" checked style="height: 34px" name="userStatus" value="${User.USER_STATUS.ENABLE}"/>Active
                            <input class="item-check" type="checkbox" checked style="height: 34px" name="userStatus" value="${User.USER_STATUS.DISABLE}"/>Inactive

                        </div>
                    </div>
                    <div class="form-group">
                        <label for="userRole" class="col-xs-4 control-label"><g:message code="app.userRole.label"/></label>
                        <div class="col" >
                            <input class="item-check" type="checkbox" checked style="height: 34px" name="userRole" value="${Role.ROLE.SURVEYOR}"/>Surveyor
                            <input class="item-check" type="checkbox" checked style="height: 34px" name="userRole" value="${Role.ROLE.RESPONDENT}"/>Respondent

                        </div>
                    </div>
                    <div class="form-group">
                        <label for="username" class="col-xs-4 control-label"><g:message code="app.username.label"/></label>
                        <div class="col-xs-8"><g:textField name="username" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>
                    <div class="form-group">
                        <label for="subject" class="col-xs-4 control-label"><g:message code="app.subject.label"/></label>
                        <div class="col-xs-8"><g:textField name="subject" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>
                    <div class="form-group">

                        <div class="col-xs-10">
                            <label class="col-xs-2 control-label"/> </label>
                            <g:textArea name="content" class="form-control" style="min-width: 80%; width: auto;" rows="10"/></div>
                    </div>
                </g:form>
            </div>
            <div class="modal-footer">
                <button id="createNewEmail" class="btn btn-green" data-loading-text="Processing..">Send</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!-- Delete users modal -->
<div id="delete-email-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="deleteEmailLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="deleteEmailLabel" class="modal-title">
                    Delete Email
                </span>
            </div>
            <div class="modal-body">
                <g:form name="deleteEmailForm" controller="email" action="deleteEmails" role="form">
                    <input type="hidden" id="delEmailIds" name="delEmailIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to delete these emails?</b></p>
                        There is no rollback for deleted emails. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="deleteEmails" class="btn btn-danger" data-loading-text="Processing..">Delete</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>
    </div>
</div>



<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {

        /* Add new user submit button */
        $('#createNewEmail').click(function() {
            $(this).button('loading');
            var form = $('#addNewEmailForm');
            if (form.valid()) {
                form.submit();
            } else {
                $(this).button('reset');
            }
        });

        /* Delete users */
        $('#deleteEmails').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#deleteEmailsForm');
            $('input[name=emailIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#delEmailIds', form).val(selected);
            form.submit();
        });



        // Validations
        $('#addNewEmailForm').validate({
            rules: {

                subject: {
                    required: true
                },
                content: {
                    required: true
                }
            }
        });


    });
</script>
</body>
</html>