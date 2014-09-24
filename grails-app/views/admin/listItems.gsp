<%@ page import="ticbox.User; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title>Administrator Page : Items</title>
    <style type="text/css">

    </style>
</head>
<body>
<div class="module">
    <div id="adminHeader" class="module-header">
        <div class="title">Items</div>
    </div>
    <div id="itemList" class="module-content">
        <div class="row" style="margin-bottom:10px">
            <div class="col-sm-12">
                <a id="addNewItems" href="#add-new-item-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> New Item</a>
                <a id="delItems" href="#delete-items-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Delete</a>

            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <table id="itemTable" class="table table-bordered table-striped table-hover">
                    <thead>
                    <tr>
                        <th></th>
                        <th>Item Name</th>
                        <th>Gold</th>

                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${items}" var="item" >
                        <tr>
                            <td><input type="checkbox" name="itemIds"  value="${item.id}" /></td>
                            <td>${item.itemName}</td>
                            <td>${item.gold}</td>

                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<!-- Add new user modal -->
<div id="add-new-item-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="addNewItemLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="addNewItemLabel" class="modal-title">
                    Add New Item
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <g:form name="addNewItemForm" controller="admin" action="createItem" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="itemName" class="col-xs-4 control-label"><g:message code="app.itemname.label"/></label>
                        <div class="col-xs-8"><g:textField name="itemName" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>
                    <div class="form-group">
                        <label for="gold" class="col-xs-4 control-label"><g:message code="app.gold.label"/></label>
                        <div class="col-xs-8"><g:textField name="gold" class="form-control" style="min-width: 70%; width: auto;"/></div>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="createNewItem" class="btn btn-green" data-loading-text="Processing..">Create New Item</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!-- Delete users modal -->
<div id="delete-items-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="deleteItemsLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="deleteItemsLabel" class="modal-title">
                    Delete Items
                </span>
            </div>
            <div class="modal-body">
                <g:form name="deleteItemsForm" controller="admin" action="deleteItems" role="form">
                    <input type="hidden" id="delItemIds" name="delItemIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to delete these items?</b></p>
                        There is no rollback for deleted items. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="deleteItems" class="btn btn-danger" data-loading-text="Processing..">Delete</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>
    </div>
</div>


<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {

        /* Add new item submit button */
        $('#createNewItem').click(function() {
            $(this).button('loading');
            var form = $('#addNewItemForm');
            if (form.valid()) {
                form.submit();
            } else {
                $(this).button('reset');
            }
        });

        /* Delete items */
        $('#deleteItems').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#deleteItemsForm');
            $('input[name=itemIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#delItemIds', form).val(selected);
            form.submit();
        });



        // Validations
        $('#addNewItemForm').validate({
            rules: {
                itemName: {
                    required: true
                },
                gold:{
                    required:true,
                    number: true
                }
            }
        });


    });
</script>
</body>
</html>