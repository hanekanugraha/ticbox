<%@ page import="ticbox.User; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title>Administrator Page : Users</title>
    <style type="text/css">

    </style>
</head>
<body>
    <div class="module">
        <div id="adminHeader" class="module-header">
            <div class="title">Users</div>
        </div>
        <div id="userList" class="module-content">
            <div class="row" style="margin-bottom:10px">
                <div class="col-sm-12">
                    <a id="addNewUser" href="#add-new-user-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> New User</a>
                    <a id="delUsers" href="#delete-users-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Delete</a>
                    <a id="dactiveUsers" href="#active-users-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Reactive/Inactive</a>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <table id="userTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th></th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Role(s)</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${users}" var="user" status="status">
                                <tr>
                                    <td><input type="checkbox" name="userIds" userstatus="${user.status}" value="${user.id}" ${SecurityUtils.getSubject().getPrincipals().oneByType(String.class)?.equals(user.username) ? 'disabled="disabled"' : ''} /></td>
                                    <td>${user.username}</td>
                                    <td>${user.email}</td>
                                    <td>${user.roles*.name}</td>
                                    <td><g:message code="${User.getStatusLabel(user.status)}"/></td>
                                </tr>
                            </g:each>
                        </tbody>
                        <tfoot>
                            <g:paginate next="Forward" prev="Back"
                                        maxsteps="3"  action="index" total="${users.size()}" max="4" />
                        </tfoot>
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
                    Add New User
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
                <button id="createNewUser" class="btn btn-green" data-loading-text="Processing..">Create New User</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
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
                    Delete Users
                </span>
            </div>
            <div class="modal-body">
                <g:form name="deleteUsersForm" controller="admin" action="deleteUsers" role="form">
                    <input type="hidden" id="delUserIds" name="delUserIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to delete these users?</b></p>
                        There is no rollback for deleted users. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="deleteUsers" class="btn btn-danger" data-loading-text="Processing..">Delete</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
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
                    Active Users
                </span>
            </div>
            <div class="modal-body">
                <g:form name="activeUsersForm" controller="admin" action="activeUsers" role="form">
                    <input type="hidden" id="activeUserIds" name="activeUserIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to inactive/reactive these users?</b></p>
                        There is no rollback for inactive/reactive users. Please make sure you know what you are doing.
                    </div>
                    <label for="dactiveReason">Please input the reason</label>
                    <input type="text" class="form-control" id="dactiveReason" name="dactiveReason" param-of="activeUsers">
                </g:form>
            </div>
            <div class="modal-footer">
                <button id="activeUsers" class="btn btn-danger" data-loading-text="Processing..">Active</button>
                <button id="cancelActiveUsers" class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>
    </div>
</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {

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

        /* Delete users */
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