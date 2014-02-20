<html>
<head>
    <meta name="layout" content="respondent"/>
    <title>Redeem Gold</title>
    <style type="text/css">
    </style>
</head>

<body>
<div id="inviteFriendsHeader" class="module-header">
    <div class="title">Redeem Gold</div>
</div>
<div id="redeemGoldForm" class="module-content">
    <div class="message-box">
        <div class="module-message">
            1 Gold = ${goldRate}
        </div>
    </div>
    <div class="row" style="margin: 20px 0 30px; padding-bottom: 20px; border-bottom: 1px solid #E8E8E8;">
        <div style="color: #6daac9; font-weight: bold">Your balance is
            <span style="font-weight: bold; font-size: 16px; color: black;">${balance}</span>
        </div>
    </div>


    <g:form name="redeemForm" class="form-horizontal">
        <div class="form-group">
            <label class="col-xs-4 control-label">
                <g:message code="app.respondent.redeemAmount.label" default="Redeem Amount"/> (min ${g.formatNumber(number: minRedemption, formatName: 'app.currency.format')})
            </label>

            <div class="col-xs-6">
                <g:textField id="redemptionAmount" name="redemptionAmount" placeholder="${g.formatNumber(number: minRedemption, maxFractionDigits: 0)}" class="form-control"/>
            </div>
        </div>

        <div class="form-group">
            <label class="col-xs-4 control-label">
                <g:message code="app.respondent.bankName.label" default="Bank Name"/>
            </label>

            <div class="col-xs-6">
                <g:textField id="bankName" name="bankName" class="form-control"/>
            </div>
        </div>

        <div class="form-group">
            <label class="col-xs-4 control-label">
                <g:message code="app.respondent.bankBranchName.label" default="Bank Branch Name"/>
            </label>

            <div class="col-xs-6">
                <g:textField id="bankBranchName" name="bankBranchName" class="form-control"/>
            </div>
        </div>

        <div class="form-group">
            <label class="col-xs-4 control-label">
                <g:message code="app.respondent.bankAccountNumber.label" default="Bank Account Number"/>
            </label>

            <div class="col-xs-6">
                <g:textField id="bankAccountNumber" name="bankAccountNumber" class="form-control"/>
            </div>
        </div>

        <div class="form-group">
            <label class="col-xs-4 control-label">
                <g:message code="app.respondent.bankAccountName.label" default="Bank Account Name"/>
            </label>

            <div class="col-xs-6">
                <g:textField id="bankAccountName" name="bankAccountName" class="form-control"/>
            </div>
        </div>
    </g:form>

    <div id="buttonBarHeader" class="module-header"></div>
        <div id="buttonBarContent" class="module-content">
            <button id="submitRequest" class="btn btn-lg btn-green">${g.message(code: 'app.submit.label')}</button>
        </div>
    </div>

</div>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">

    function submitRequest(btn) {
        if($('#redeemForm').valid()) {
            jQuery(btn).attr('disabled', 'disabled');
            var url = '${g.createLink(controller: "respondent", action: "requestRedemption")}';
            var data = $('#redeemForm').find('input').serialize();
            $.post(url, data, function(response) {
                var message = (response) ? 'Success' : 'Application error';
                alert(message);
                window.location.replace('${request.contextPath}/respondent/');
            });
        }
    }

    $(document).ready(function () {

        $('#redemptionAmount').focus();

        $('#submitRequest').click(function() {
            submitRequest(this);
        });

        $('#redeemForm').validate({
            rules: {
                redemptionAmount: {
                    required: true,
                    number: true,
                    max: ${maxRedemption},
                    min: ${minRedemption}
                },
                bankName: {
                    required: true
                },
                bankBranchName: {
                    required: true
                },
                bankAccountNumber: {
                    required: true,
                    number: true
                },
                bankAccountName: {
                    required: true
                }
            }
        });
    });

</script>
</body>
</html>