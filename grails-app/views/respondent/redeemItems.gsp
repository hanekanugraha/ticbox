<html>
<head>
    <meta name="layout" content="respondent"/>
    <title><g:message code="redeemitems.title"/> </title>
    <style type="text/css">
    </style>

    <g:javascript src="simpleCart.js"/>

</head>

<body>
<div id="inviteFriendsHeader" class="module-header">
    <div class="title"><g:message code="redeemitems.title"/></div>
</div>
<div id="redeemItemForm" class="module-content">

    <div id="itemList" class="module-content">

        <div class="row">
            <div class="col-sm-12">
                <table id="itemTable" class="table table-bordered table-striped table-hover">
                    <thead>
                    <tr>
                        <th></th>
                        <th><g:message code="app.picture.label"/> </th>
                        <th><g:message code="app.itemname.label"/> </th>
                        <th><g:message code="point.gold.label"/> </th>

                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${items}" var="item" >
                        <tr>
                            <td><input type="checkbox" name="itemIds"  value="${item.id}" gold="${item.gold}" /></td>
                            <td>
                              <img class="pic upload-pic" id="item-pic${item.id}"
                                 <g:if test="${item.pic != null}">src="data:image;base64,${item.pic}"</g:if>
                                 <g:else>src="/ticbox/images/ticbox/no-image.png"</g:else>
                              /></td>
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
    <a id="redeem" href="#redeem-item-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> <g:message code="app.redeem.label"/> </a>



<p>
    <g:message code="app.cart.label"/> : <span class="simpleCart_total"></span> (<span id="simpleCart_quantity" class="simpleCart_quantity"></span> <g:message code="admin.items.label"/> )
    <br />
    <a href="javascript:;" class="simpleCart_empty"><g:message code="redeemitems.empty-cart.label"/> </a>
    <br />
</p>
<table id="itemTable2" class="table table-bordered table-striped table-hover">
    <thead>
    <tr>
        %{--<th></th>--}%
        <th><g:message code="app.picture.label"/> </th>
        <th><g:message code="app.itemname.label"/> </th>
        <th><g:message code="app.quantity.label"/> </th>
        <th><g:message code="point.gold.label"/> </th>
        <th><g:message code="app.action.label"/> </th>

    </tr>
    </thead>
    <tbody>
    <g:each in="${items}" var="item" >
        <tr class="simpleCart_shelfItem">
            %{--<td><input type="checkbox" name="itemIds"  value="${item.id}" gold="${item.gold}" /></td>--}%
            <td>${item.pic}</td>
            <td class="item_name">${item.itemName}</td>
            <td><input type="text" value="1" class="item_quantity"></td>
            <td class="item_price">${item.gold}</td>
            <td><a class="item_add" href="javascript:;"> <g:message code="redeemitems.add-to-cart.label"/> </a></td>
            <td hidden="true" class="item_code">${item.id}</td>
        </tr>
    </g:each>
    </tbody>
</table>

    <div class="simpleCart_items" >
    </div>

    <g:message code="app.finaltotal.label"/> : <span id="simpleCart_grandTotal" class="simpleCart_grandTotal"></span> <br />

    <a href="javascript:;simpleCart.empty();" class="simpleCart_checkout"><g:message code="app.checkout.label"/> </a>



</div>

<div id="redeem-item-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="redeemItemsLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="redeemItemsLabel" class="modal-title">
                    <g:message code="redeemitems.title"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="redeemItemsForm" controller="respondent" action="requestItemsRedemption" role="form">
                    <input type="hidden" id="redeemItemIds" name="redeemItemIds" value=""/>
                    <div class="well">
                        <p><b><g:message code="redeemitems.validation.label"/> </b></p>
                        <g:message code="redeemitems.validation.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="redeemItems" class="btn btn-danger" data-loading-text="Processing.."><g:message code="app.redeem.label"/> </button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/> </button>
            </div>
        </div>
    </div>
</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>



<script type="text/javascript">

    simpleCart({
        checkout: {
            type: "SendForm",
            url: "/ticbox/respondent/requestItemsRedemptionCart"
        }
    });

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