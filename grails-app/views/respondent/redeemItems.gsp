<html>
<head>
    <meta name="layout" content="respondent"/>
    <title>Redeem Items</title>
    <style type="text/css">
    </style>
</head>

<body>
<div id="inviteFriendsHeader" class="module-header">
    <div class="title">Redeem Items</div>
</div>
<div id="redeemItemForm" class="module-content">

    <div id="itemList" class="module-content">

        <div class="row">
            <div class="col-sm-12">
                <table id="itemTable" class="table table-bordered table-striped table-hover">
                    <thead>
                    <tr>
                        <th></th>
                        <th>Pic</th>
                        <th>Item Name</th>
                        <th>Gold</th>

                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${items}" var="item" >
                        <tr>
                            <td><input type="checkbox" name="itemIds"  value="${item.id}" gold="${item.gold}" /></td>
                            <td>${item.pic}</td>
                            <td>${item.itemName}</td>
                            <td>${item.gold}</td>

                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <div id="buttonBarHeader" class="module-header"></div>
    <a id="redeem" href="#redeem-item-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> Redeem</a>



</div>

<div id="redeem-item-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="redeemItemsLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="redeemItemsLabel" class="modal-title">
                    Redeem Items
                </span>
            </div>
            <div class="modal-body">
                <g:form name="redeemItemsForm" controller="respondent" action="requestItemsRedemption" role="form">
                    <input type="hidden" id="redeemItemIds" name="redeemItemIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to redeem these items?</b></p>
                        There is no rollback for redeem items. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="redeemItems" class="btn btn-danger" data-loading-text="Processing..">Redeem</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
        </div>
    </div>
</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">



    $(document).ready(function () {

        $('#redeemItems').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#redeemItemsForm');
            $('input[name=itemIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);

            });
            $('#redeemItemIds', form).val(selected);
            form.submit();

        });


    });

</script>
</body>
</html>