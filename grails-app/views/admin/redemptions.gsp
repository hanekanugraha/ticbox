<%@ page import="ticbox.Item; ticbox.User; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title><g:message code="ticbox.admin.redemptions.label"/></title>
    <style type="text/css">
        .fade-text {
            color: #bfbfbf;
            font-style: italic;
        }
    </style>
    <script>
      function disableCheckbox(checkbox) {
        checkbox.attr('disabled', 'disabled');
        checkbox.attr('title', 'Please complete the information first');
      }

      function enableCheckbox(checkbox) {
        checkbox.attr('disabled', null);
        checkbox.attr('class', null);
      }
    </script>
</head>
<body>
    <h3><g:message code="admin.redemptions.money.label"/></h3>

    %{--<div class="row-fluid">--}%
        %{--<div class="span2">--}%
            %{--<g:select class="input-medium" name="newStatusSelect" from="${redemptionStatuses.entrySet()}" optionKey="key" optionValue="value"/>--}%
        %{--</div>--}%
        %{--<div class="span2">--}%
            %{--<a id="changeStatus" role="button" class="btn" data-loading-text="Processing.."><i class="icon-tag"></i> Change Status</a>--}%
        %{--</div>--}%
    %{--</div>--}%
    <div class="row" style="margin-bottom:10px">
        <div class="col-sm-12">
            <a id="approveRedemps" href="#approve-submitted-redemp-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> <g:message code="label.button.approve"/></a>
            <a id="rejectRedemps" href="#reject-submitted-redemp-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> <g:message code="label.button.reject"/></a>
        </div>
    </div>
    <br />

    <table id="redemptionTable" class="table table-bordered table-striped">
        <thead>
            <tr>
                <th></th>
                <th><g:message code="app.redemptiondate.label"/></th>
                <th><g:message code="app.name.title"/></th>
                <th><g:message code="app.amount.label"/></th>
                <th><g:message code="app.bankname.label"/></th>
                <th><g:message code="app.accountno.label"/></th>
                <th><g:message code="app.accountname.label"/></th>
                <th><g:message code="app.status.label"/></th>
                <th><g:message code="app.information.label"/></th>
            </tr>
        </thead>
        <tbody>
            <g:each in="${redemptionRequestList}" var="redemption" status="status">
                <tr>
                    <td><input type="checkbox" name="redemptionIds" value="${redemption.id}" class="row-checkbox" /></td>
                    <td>${redemption.dateCreated}</td>
                    <td>${redemption.respondentUsername}</td>
                    <td>${g.formatNumber(number: redemption.redemptionAmount, formatName: 'app.currency.format')}</td>
                    <td>${redemption.bankName}</td>
                    <td>${redemption.bankAccountNumber}</td>
                    <td>${redemption.bankAccountName}</td>
                    <td>${redemption.status}</td>
                    <td class="redemption-info">
                        <g:if test="${redemption.info != null}">
                        %{--<a href="#edit-info-modal" role="button" data-toggle="modal" data-argument="${redemption.id}" data-type="money">--}%
                            ${redemption.info}
                        %{--</a>--}%
                        </g:if>
                        <g:else>
                        %{--<a href="#edit-info-modal" role="button" data-toggle="modal" data-type="money" class="fade-text">--}%
                            &lt;blank&gt;
                        %{--</a>--}%
                        </g:else>
                    </td>
                </tr>
            </g:each>
        </tbody>
    </table>

    <h3><g:message code="admin.redemptions.items.label"/></h3>


    <div class="row" style="margin-bottom:10px">
        <div class="col-sm-12">
            <a id="approveItemRedemps"  role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> <g:message code="label.button.approve"/></a>
            <a id="rejectItemRedemps" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> <g:message code="label.button.reject"/></a>
        </div>
    </div>
    <br />
<g:each in="${redemptionItemRequestList}" var="redemptionItem">
</g:each>
<table id="redemptionItemTable" class="table table-bordered table-striped">
    <thead>
    <tr>
        <th></th>
        <th><g:message code="app.redemptiondate.label"/></th>
        <th><g:message code="app.name.title"/></th>
        <th><g:message code="app.goldamount.label"/></th>
        <th><g:message code="admin.items.label"/></th>
        <th><g:message code="app.status.label"/></th>
        <th><g:message code="app.information.label"/></th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${redemptionItemRequestList}" var="redemptionItem">
        <tr>
            <td><input type="checkbox" name="redemptionItemIds" value="${redemptionItem.id}" /></td>
            <td>${redemptionItem.dateCreated}</td>
            <td>${redemptionItem.respondentUsername}</td>
            <td>${redemptionItem.goldAmount}</td>
            <td><g:each in="${redemptionItem.ITEMS}" var="item" status="status">
                ${Item.findById(item)?.itemName}
                ${Item.findById(item)?.gold}
                <br/>
                </g:each>
            </td>
            <td>${redemptionItem.status}</td>
            <td class="redemption-info">
                <g:if test="${redemptionItem.info != null}" >
                %{--<a href="#edit-info-modal" role="button" data-toggle="modal" data-type="item">--}%
                    ${redemptionItem.info}
                %{--</a>--}%
                </g:if>
                <g:else>
                <a data-toggle="modal" data-type="item" class="fade-text">
                    &lt;blank&gt;
                </a>
                </g:else>
            </td>

            <td class="content-width">
                <a class="btn btn-xs btn-primary setInfoLink" redeemtionitemid="${redemptionItem.id}" redeemtioniteminfo="${redemptionItem.info}" href="javascript:void(0)">Set Info</a>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>

<div id="approve-submitted-redemp-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="approveRedempLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="approveRedempLabel" class="modal-title">
                    <g:message code="admin.approveredeem.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="approveRedempsForm" controller="admin" action="approveRedemps" role="form">
                    <input type="hidden" id="approveRedempIds" name="approveRedempIds" value=""/>
                    <div class="well">
                        <p><b><g:message code="admin.approveredeem.title"/></b></p>
                        <g:message code="admin.approveredeem.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="approveRedemp" class="btn btn-danger" data-loading-text="Processing.."><g:message code="label.button.approve"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<div id="reject-submitted-redemp-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="rejectRedempLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="rejectRedempLabel" class="modal-title">
                    <g:message code="admin.rejectredeem.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="rejectRedempsForm" controller="admin" action="rejectRedemps" role="form">
                    <input type="hidden" id="rejectRedempIds" name="rejectRedempIds" value=""/>
                    <div class="well">
                        <p><b><g:message code="admin.rejectredeem.title"/></b></p>
                        <g:message code="admin.rejectredeem.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="rejectRedemp" class="btn btn-danger" data-loading-text="Processing.."><g:message code="label.button.reject"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>



<div id="approve-submitted-redemp-item-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="approveRedempLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="approveRedempItemLabel" class="modal-title">
                    <g:message code="admin.approveredeem.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="approveRedempsItemForm" controller="admin" action="approveRedempsItem" role="form">
                    <input type="hidden" id="approveRedempItemIds" name="approveRedempItemIds" value=""/>
                    <div class="well">
                        <p><b><g:message code="admin.approveredeem.title"/></b></p>
                        <g:message code="admin.approveredeem.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="approveRedempItemAction" class="btn btn-danger" data-loading-text="Processing.."><g:message code="label.button.approve"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>

<div id="reject-submitted-redemp-item-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="rejectRedempItemLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="rejectRedempItemLabel" class="modal-title">
                    <g:message code="admin.rejectredeem.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="rejectRedempsItemForm" controller="admin" action="rejectRedempsItem" role="form">
                    <input type="hidden" id="rejectRedempItemIds" name="rejectRedempItemIds" value=""/>
                    <div class="well">
                        <p><b><g:message code="admin.rejectredeem.title"/></b></p>
                        <g:message code="admin.rejectredeem.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="rejectRedempItemAction" class="btn btn-danger" data-loading-text="Processing.."><g:message code="label.button.reject"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>


<g:form name="changeRedemptionStatusForm" action="changeRedemptionStatus">
    <g:hiddenField name="redemptionIds"></g:hiddenField>
    <g:hiddenField name="newStatus"></g:hiddenField>
</g:form>
</div>

<div id="edit-info-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="editInfoLabel" >
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="editInfoLabel" class="modal-title">
                    <g:message code="redeemItems.info.label"/>
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <g:form name="editInfoForm" controller="admin" action="updateRedemptionInfo" class="form-horizontal" role="form">
                    <input type="hidden" id="redemptionId" name="redemptionId" />
                    <input type="hidden" id="redemptionType" name="redemptionType" />
                    <div class="form-group">
                        <div class="col-xs-8">
                            <g:textArea id="infoText" name="infoText" class="form-control" rows="5" cols="500" style="width:500px" />
                        </div>
                    </div>
                </g:form>
            </div>
            <div class="modal-footer">
                <button id="update-info-btn" class="btn btn-green" data-loading-text="Processing.."><g:message code="app.ok.label"/> </button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>
</div>
<!-- Validate Choice Question Items modal -->
<div id="validate-redeem-list-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="validateRedeemListLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="validateChoiceQuestionItemsLabel" class="modal-title">
                    <g:message code="redeemtion.validate.title"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="validateQuestionItemsForm" role="form">
                    <div class="well">
                        <p><b><g:message code="redeemtion.validate.header"/> </b></p>
                        <g:message code="redeemtion.validate.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="validateRedeemListBtn" class="btn btn-danger" data-dismiss="modal" aria-hidden="true"><g:message code="app.ok.label"/></button>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function() {

        $('#changeStatus').click(function() {
            if (confirm('Change all statuses?')) {
                $('#changeStatus').button('loading');
                var selected = [];
                var form = $('#changeRedemptionStatusForm');
                $('input[name=redemptionIds]:checked').each(function(id, elmt) {
                    selected.push(elmt.value);
                });
                $('#redemptionIds', form).val(selected);
                $('#newStatus', form).val($('#newStatusSelect').val());
                form.submit();
            }
        });

        $('#approveRedemp').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#approveRedempsForm');
            $('input[name=redemptionIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#approveRedempIds', form).val(selected);
            form.submit();
        });

        $('#approveRedempItemAction').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#approveRedempsItemForm');
            $('input[name=redemptionItemIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });

            $('#approveRedempItemIds', form).val(selected);
            form.submit();

        });

        $('#rejectRedemp').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#rejectRedempsForm');
            $('input[name=redemptionIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#rejectRedempIds', form).val(selected);
            form.submit();
        });

        $('#rejectRedempItemAction').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#rejectRedempsItemForm');
            $('input[name=redemptionItemIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#rejectRedempItemIds', form).val(selected);
            form.submit();
        });

//        $('.redemption-info a').click(function() {
//
//            $('#edit-info-modal input[name=redemptionId]').val(id);
//            $('#edit-info-modal input[name=redemptionType]').val(type);
//            $('#edit-info-modal textarea').val(content);
//            $('#edit-info-modal').modal('show');
//            $('#edit-info-modal textarea').focus();
//        });

        $('#approveItemRedemps').click(function() {
            var selected = [];
            $('input[name=redemptionItemIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });

            if(selected.length==0) {
                $('#validate-redeem-list-modal').modal('show');
            } else {
                $('#approve-submitted-redemp-item-modal').modal('show');
            }
        })

        $('#rejectItemRedemps').click(function () {
            var selected = [];
            $('input[name=redemptionItemIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            if(selected.length==0) {
                $('#validate-redeem-list-modal').modal('show');
            } else {
                $('#reject-submitted-redemp-item-modal').modal('show');
            }
        })

        //kucing
        $(document).on('click',".setInfoLink",function() {
            var that = jQuery(this);
            var redeemtionitemid = that.attr('redeemtionitemid');
            var redemptionType = 'item';
            var infoText = that.attr('redeemtioniteminfo');

            $('#redemptionId').val(redeemtionitemid);
            $('#redemptionType').val(redemptionType);
            $('#infoText').val(infoText);
            $('#edit-info-modal').modal('show');


        });

//        kucing edit
        $('#update-info-btn').click(function() {
            $(this).button('loading');
//            var redemptionId = $('#edit-info-modal form input[name=redemptionId]').val();
//            var redemptionType = $('#edit-info-modal form input[name=redemptionType]').val();
//            var infoText = $('#edit-info-modal form textarea[name=infoText]').val();

            var form= $('#editInfoForm');
            form.submit();

//            $.post('/ticbox/admin/updateRedemptionInfo', {rid: redemptionId, type: redemptionType, info: infoText}, function(data) {
//                if (data.success) {
//                  var checkbox = $(':checkbox[value=' + redemptionId + ']');
//                  $('.redemption-info a', checkbox.parents('tr')).html(infoText);
//                  enableCheckbox(checkbox);
//                } else {
//                  alert('Failed: ' + data.message);
//                }
//            }).fail(function() {
//                alert('Failed: Server not responding');
//            }).always(function() {
//                $('#edit-info-modal').modal('toggle');
//            });
        });

        $('tbody tr').each(function(index, dataRow){
            var cls = $('.redemption-info a', dataRow).attr('class');
            if (cls == 'fade-text') {
                disableCheckbox($(':checkbox', dataRow));
            }
        });

    });
</script>
</body>
</html>