<%@ page import="ticbox.User; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title><g:message code="ticbox.admin.users.title"/></title>
    <style type="text/css">

    </style>
</head>
<body>
    <div class="module">
        <div id="adminHeader" class="module-header">
            <div class="title"><g:message code="app.users.label"/></div>
        </div>
        <div id="userList" class="module-content">
            <div class="row" style="margin-bottom:10px">
                <div class="col-sm-12">
                    <a id="addNewUser" href="#add-new-user-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> <g:message code="default.button.newusers.label"/></a>
                    <a id="btnDeleteUsers" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> <g:message code="default.button.delete.label"/></a>
                    <a id="dactiveUsers" href="#active-users-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> <g:message code="default.button.activeatereactivate.label"/></a>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <table id="userTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th></th>
                                <th><g:message code="app.username.label"/></th>
                                <th><g:message code="app.email.label"/></th>
                                <th><g:message code="app.roles.label"/></th>
                                <th><g:message code="app.status.label"/></th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${users}" var="user" status="status">
                                <tr>
                                    <td><input type="checkbox" name="userIds" userstatus="${user.status}" value="${user.id}" ${SecurityUtils.getSubject().getPrincipals().oneByType(String.class)?.equals(user.username) ? 'disabled="disabled"' : ''} /></td>
                                    <td><g:link controller="admin" action="editProfile" params="[uid: user.id, type: user.roles*.name]">${user.username}</g:link></td>
                                    <td>${user.email}</td>
                                    <td>${user.roles*.name}</td>
                                    <td><g:message code="${User.getStatusLabel(user.status)}"/></td>
                                </tr>
                            </g:each>
                        </tbody>

                    </table>

                </div>
            </div>

        </div>
    </div>

<!-- Add new user modal -->
<div id="add-new-user-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="addNewUserLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="addNewUserLabel" class="modal-title">
                    <g:message code="label.button.createnewuser"/>
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <g:form name="addNewUserForm" controller="admin" action="createUser" class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="userType" class="col-xs-4 control-label"><g:message code="app.userType.label"/></label>
                        <div class="col-xs-8"><g:select name="userType" from="${userTypes}" class="form-control" style="min-width: 40%; width: auto;"/></div>
                    </div>
                    <div class="form-group">
                        <label for="username" class="col-xs-4 control-label"><g:message code="app.username.label"/></label>
                        <div class="col-xs-8"><g:textField name="username" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>
                    <div class="form-group">
                        <label for="email" class="col-xs-4 control-label"><g:message code="app.email.label"/></label>
                        <div class="col-xs-8"><g:textField name="email" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>
                    <div class="form-group">
                        <label for="password" class="col-xs-4 control-label"><g:message code="app.password.label"/></label>
                        <div class="col-xs-8"><g:passwordField name="password" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>
                    <div class="form-group">
                        <label for="passwordconfirm" class="col-xs-4 control-label"><g:message code="app.passwordconfirm.label"/></label>
                        <div class="col-xs-8"><g:passwordField name="passwordconfirm" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>
                    <div class="form-group">
                        <label for="company" class="col-xs-4 control-label"><g:message code="app.company.label"/></label>
                        <div class="col-xs-8"><g:textField name="company" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>
                </g:form>
            </div>
            <div class="modal-footer">
                <button id="createNewUser" class="btn btn-green" data-loading-text="Processing.."><g:message code="label.button.createnewuser"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<!-- Delete users modal -->
<div id="delete-users-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="deleteUsersLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="deleteUsersLabel" class="modal-title">
                    <g:message code="admin.validate.deleteuser.header"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="deleteUsersForm" controller="admin" action="deleteUsers" role="form">
                    <input type="hidden" id="delUserIds" name="delUserIds" value=""/>
                    <div class="well">
                        <p><b><span id="labelHeaderModal" name="labelHeaderModal" text=""/></b></p>
                        <span id="labelText" name="labelText" text="Please answer the question before you go to the next step."/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="deleteUsers" class="btn btn-danger" data-loading-text="Processing.."><g:message code="default.button.delete.label"/></button>
                <button id="cancelUsers" class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<!-- Activeation users modal -->
<div id="active-users-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="activeUsersLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="ActiveUsersLabel" class="modal-title">
                    <g:message code="admin.validate.activateuser.header"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="activeUsersForm" controller="admin" action="activeUsers" role="form">
                    <input type="hidden" id="activeUserIds" name="activeUserIds" value=""/>
                    <div class="well">
                        <p><b><g:message code="admin.validate.activateuser.title"/></b></p>
                        <g:message code="admin.validate.activateuser.content"/>
                    </div>
                    <label for="dactiveReason"><g:message code="admin.validate.activateuser.reason"/></label>
                    <input type="text" class="form-control" id="dactiveReason" name="dactiveReason" param-of="activeUsers">
                </g:form>
            </div>
            <div class="modal-footer">
                <button id="activeUsers" class="btn btn-danger" data-loading-text="Processing.."><g:message code="default.button.activeatereactivate.label"/></button>
                <button id="cancelActiveUsers" class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {

        $('#userTable').DataTable( {
            "ordering": true,
            "info":     false,
            "searching": true,
            "oLanguage": {
                "sEmptyTable":     "No User found..",
                "sLengthMenu": 'Display <select>'+
                        '<option value="5">5</option>'+
                        '<option value="10">10</option>'+
                        '<option value="20">20</option>'+
                        '<option value="-1">All</option>'+
                        '</select> records'
            }

        } );

        /* Add new user submit button */
        $('#createNewUser').click(function() {
            $(this).button('loading');
            var form = $('#addNewUserForm');
            if (form.valid()) {
                form.submit();
            } else {
                $(this).button('reset');
            }
        });

        /* kucingkurus function */
        $('#btnDeleteUsers').click(function() {
            var form = $('#deleteUsersForm');
            var selected = [];

            $('input[name=userIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });

            if(selected==null||selected==undefined||selected=="") {
                $('#labelHeaderModal', form).text('<g:message code="admin.validate.nouser.title"/>');
                $('#labelText', form).text('<g:message code="admin.validate.nouser.content"/>');
                jQuery('#deleteUsers').hide();
                $("#cancelUsers").text("<g:message code="app.ok.label"/>");
                $('#delete-users-modal').modal('show');
            } else {
                $('#labelHeaderModal', form).text('<g:message code="admin.validate.deleteuser.title"/>');
                $('#labelText', form).text('<g:message code="admin.validate.deleteuser.content"/>');
                jQuery('#deleteUsers').show();
                $("#cancelUsers").text("<g:message code="label.button.cancel"/>");
                $('#delete-users-modal').modal('show');
            }

        });

        /* Delete users modal function */
        $('#deleteUsers').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#deleteUsersForm');
            $('input[name=userIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#delUserIds', form).val(selected);
            form.submit();
        });

        $('#activeUsers').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#activeUsersForm');
            var status= null
            var checking=true
            $('input[name=userIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
                if(status==null&&elmt.getAttribute("userstatus")!=null)
                    status=elmt.getAttribute("userstatus");
                if(status!=null&&elmt.getAttribute("userstatus")!=null&&status!=elmt.getAttribute("userstatus")){
                    alert("user not same");
                    checking= false;
                }
            });
            if(checking) {
                $('#activeUserIds', form).val(selected);
                form.submit();
            }else{
                $('#cancelActiveUsers').click();
            }
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