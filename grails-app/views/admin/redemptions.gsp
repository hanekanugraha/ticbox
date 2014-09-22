<%@ page import="ticbox.User; org.apache.shiro.SecurityUtils" %>
<html>
<head>
    <meta name="layout" content="admin"/>
    <title>Administrator Page : Redemptions</title>
    <style type="text/css">

    </style>
</head>
<body>
    <h3>Redemptions</h3>

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
            <a id="approveRedemps" href="#approve-submitted-redemp-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> Approve</a>
            <a id="rejectRedemps" href="#reject-submitted-redemp-modal" role="button" class="btn btn-danger" data-toggle="modal"><i class="icon-remove icon-white"></i> Reject</a>
        </div>
    </div>
    <br />

    <table id="redemptionTable" class="table table-bordered table-striped">
        <thead>
            <tr>
                <th></th>
                <th>Date Created</th>
                <th>Respondent ID</th>
                <th>Name</th>
                <th>Amount</th>
                <th>Bank Name</th>
                <th>Account No</th>
                <th>Account Name</th>
                <th>Status</th>
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

<div id="approve-submitted-redemp-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="approveRedempLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="approveRedempLabel" class="modal-title">
                    Approve Redemptions
                </span>
            </div>
            <div class="modal-body">
                <g:form name="approveRedempsForm" controller="admin" action="approveRedemps" role="form">
                    <input type="hidden" id="approveRedempIds" name="approveRedempIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to approve these redemption?</b></p>
                        There is no rollback for approve these redemption. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="approveRedemp" class="btn btn-danger" data-loading-text="Processing..">Approve</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
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
                    Reject Redemptions
                </span>
            </div>
            <div class="modal-body">
                <g:form name="rejectRedempsForm" controller="admin" action="rejectRedemps" role="form">
                    <input type="hidden" id="rejectRedempIds" name="rejectRedempIds" value=""/>
                    <div class="well">
                        <p><b>Are you sure to reject these redemption?</b></p>
                        There is no rollback for reject these redemption. Please make sure you know what you are doing.
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="rejectRedemp" class="btn btn-danger" data-loading-text="Processing..">Reject</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
            </div>
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
    });
</script>
</body>
</html>