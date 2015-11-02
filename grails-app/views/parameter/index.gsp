<%@ page import="ticbox.Parameter; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title><g:message code="editparameters.header"/> </title>
    <style type="text/css">

    </style>
</head>
<body>
    <div class="module">
        <div id="adminHeader" class="module-header">
            <div class="title"><g:message code="app.parameters.label"/> </div>
        </div>
        <div id="userList" class="module-content">
            <div class="row" style="margin-bottom:10px">
                <div class="col-sm-12">
                    %{--<a id="addEmail" href="#add-new-email-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> New Email</a>--}%
                    %{--<a id="delEmails" href="#delete-email-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Delete</a>--}%

                </div>
            </div>
            <div class="row">
                <div class="col-sm-12">
                    <table id="parameterTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                %{--<th></th>--}%
                                <th><g:message code="app.parameters.label"/> </th>
                                <th><g:message code="app.value.label"/> </th>


                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${parameters}" var="parameter">
                                <tr>
                                    %{--<td><input type="checkbox" name="parameterIds"  value="${parameter.id}" /></td>--}%
                                    <td><a href="${request.contextPath}/parameter/editParameter?code=${parameter.code}">${parameter.desc}</a></td>
                                    <td>${parameter.value}</td>


                                </tr>
                            </g:each>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </div>



<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {



    });
</script>
</body>
</html>