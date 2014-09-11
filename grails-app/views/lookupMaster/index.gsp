<%@ page import="ticbox.LookupMaster; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title>Administrator Page : Lookup</title>
    <style type="text/css">

    </style>
</head>
<body>
    <div class="module">
        <div id="adminHeader" class="module-header">
            <div class="title">Lookup</div>
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
                    <table id="lookupTable" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                %{--<th></th>--}%
                                <th>Lookup Code</th>
                                <th>Label</th>


                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${lookupMasters}" var="lookupMaster">
                                <tr>
                                    %{--<td><input type="checkbox" name="parameterIds"  value="${parameter.id}" /></td>--}%
                                    <td><a href="${request.contextPath}/lookupMaster/editLookup?code=${lookupMaster.code}">${lookupMaster.code}</a></td>
                                    <td>${lookupMaster.label}</td>


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