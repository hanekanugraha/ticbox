<html>
<head>
    <meta name="layout" content="respondent"/>
    <title><g:message code="redeemitems.title"/> </title>
    <style type="text/css">
    .thumbnail2 {
      width: 25px;
    }
    .zoomable {
      -webkit-transition: all .2s ease-in-out;
      -moz-transition: all .2s ease-in-out;
      -o-transition: all .2s ease-in-out;
      -ms-transition: all .2s ease-in-out;
    }
    .zoomable-transition {
      -webkit-transform: scale(5); 
      -moz-transform: scale(5);
      -o-transform: scale(5);
      transform: scale(5);
    }
    </style>
    <script>
    $(document).ready(function(){
      $('.zoomable').hover(function() {
        $(this).addClass('zoomable-transition');

        }, function() {
          $(this).removeClass('zoomable-transition');
        });

      $('input[name=quantity]').bind('keyup mouseup', function() {
        onQuantityUpdated(this);
      });

      updateTotalInfo();
    });

    function onQuantityUpdated(input) {
        var quantity = parseInt($(input).val());
        if (quantity > 0) {
            setHighlight($(input).parents('tr'), true);
        } else {
            setHighlight($(input).parents('tr'), false);
        }

        updateTotalInfo();
    }

    function updateTotalInfo() {
        var totalPointRequired = 0;

        $('#itemTable tbody tr').each(function(index){
            var input = $(this).find('input[name=quantity]');
            var quantity = parseInt($(input).val());

            var pointPerItem = parseInt($(input).parents('tr').find(':hidden[data-gold]').attr('data-gold'));
            var pointRequired = quantity * pointPerItem;

            // Update point required for this item
            $(this).find('.pointRequired').text(pointRequired);    

            totalPointRequired += pointRequired;
        });

        $('#totalPointRequired').text(totalPointRequired);
        return totalPointRequired;
    }

    function setHighlight(tr, active) {
        if (active) {
            $(tr).addClass('active');
        } else {
            $(tr).removeClass('active');
        }
    }
</script>
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
                            <th>Item</th>
                            <th>Point Per Item</th>
                            <th>Quantity Desired</th>
                            <th>Point Required</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${items}" var="item" >
                        <tr>
                            <td>
                              <input type="hidden" name="itemIds" value="${item.id}" data-gold="${item.gold}" />
                              <img id="item-pic${item.id}"
                                 <g:if test="${item.pic != null}"> class="thumbnail2 zoomable" src="data:image;base64,${item.pic}"</g:if>
                                 <g:else> class="thumbnail2" src="/ticbox/images/ticbox/no-image.png" title="No image available"</g:else>
                              />
                              <strong>${item.itemName}</strong>
                            </td>
                            <td>${item.gold}</td>
                            <td><input type="number" name="quantity" min="0" max="9" value="0"/></td>
                            <td class="pointRequired">0</td>
                        </tr>
                    </g:each>
                    </tbody>
                    <tfoot>
                        <tr class="borderless">
                            <th>Point you have</th>
                            <th>300</th>
                            <th>Total point required</th>
                            <th id="totalPointRequired">0</th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>

    </div>

    <a id="redeem" href="#redeem-item-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> <g:message code="app.redeem.label"/> </a>
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