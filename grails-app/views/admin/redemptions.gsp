<%@ page import="ticbox.Item; ticbox.User; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title><g:message code="ticbox.admin.redeemtions.label"/></title>
    <style type="text/css">

    </style>
</head>
<body>
    <h3><g:message code="admin.redeemtions.money.label"/></h3>

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
                <th><g:message code="app.createddate.label"/></th>
                <th><g:message code="app.respondentid.label"/></th>
                <th><g:message code="app.name.title"/></th>
                <th><g:message code="app.amount.label"/></th>
                <th><g:message code="app.bankname.label"/></th>
                <th><g:message code="app.accountno.label"/></th>
                <th><g:message code="app.accountname.label"/></th>
                <th><g:message code="app.status.label"/></th>
            </tr>
        </thead>
        <tbody>
            <g:each in="${redemptionRequestList}" var="redemption" status="status">
                <tr>
                    <td><input type="checkbox" name="redemptionIds" value="${redemption.id}" /></td>
                    <td>${redemption.dateCreated}</td>
                    <td>${redemption.respondentId}</td>
                    <td>${redemption.respondentUsername}</td>
                    <td>${g.formatNumber(number: redemption.redemptionAmount, formatName: 'app.currency.format')}</td>
                    <td>${redemption.bankName}</td>
                    <td>${redemption.bankAccountNumber}</td>
                    <td>${redemption.bankAccountName}</td>
                    <td>${redemption.status}</td>
                </tr>
            </g:each>
        </tbody>
    </table>

    <h3><g:message code="admin.redeemtions.items.label"/></h3>


    <div class="row" style="margin-bottom:10px">
        <div class="col-sm-12">
            <a id="approveItemRedemps" href="#approve-submitted-redemp-item-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> <g:message code="label.button.approve"/></a>
            <a id="rejectItemRedemps" href="#reject-submitted-redemp-item-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> <g:message code="label.button.reject"/></a>
        </div>
    </div>
    <br />

<table id="redemptionItemTable" class="table table-bordered table-striped">
    <thead>
    <tr>
        <th></th>
        <th><g:message code="app.createddate.label"/></th>
        <th><g:message code="app.respondentid.label"/></th>
        <th><g:message code="app.name.title"/></th>
        <th><g:message code="app.goldamount.label"/></th>
        <th><g:message code="admin.items.label"/></th>
        <th><g:message code="app.status.label"/></th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${redemptionItemRequestList}" var="redemptionItem">
        <tr>
            <td><input type="checkbox" name="redemptionItemIds" value="${redemptionItem.id}" /></td>
            <td>${redemptionItem.dateCreated}</td>
            <td>${redemptionItem.respondentId}</td>
            <td>${redemptionItem.respondentUsername}</td>
            <td>${redemptionItem.goldAmount}</td>
            <td><g:each in="${redemptionItem.ITEMS}" var="item" status="status">
                ${Item.findById(item)?.itemName}
                ${Item.findById(item)?.gold}
                <br/>
                </g:each>
            </td>
            <td>${redemptionItem.status}</td>
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
                <span id="approveRedempLabel" class="modal-title">
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
                <button id="approveRedempItem" class="btn btn-danger" data-loading-text="Processing.."><g:message code="label.button.approve"/></button>
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
                <button id="rejectRedempItem" class="btn btn-danger" data-loading-text="Processing.."><g:message code="label.button.reject"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
            </div>
        </div>
    </div>


<g:form name="changeRedemptionStatusForm" action="changeRedemptionStatus">
    <g:hiddenField name="redemptionIds"></g:hiddenField>
    <g:hiddenField name="newStatus"></g:hiddenField>
</g:form>

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

        $('#approveRedempItem').click(function() {
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

        $('#rejectRedempItem').click(function() {
            $(this).button('loading');
            var selected = [];
            var form = $('#rejectRedempsItemForm');
            $('input[name=redemptionItemIds]:checked').each(function(id, elmt) {
                selected.push(elmt.value);
            });
            $('#rejectRedempItemIds', form).val(selected);
            form.submit();
        });
    });
</script>
</body>
</html>