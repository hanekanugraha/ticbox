<%@ page import="net.tanesha.recaptcha.ReCaptcha; net.tanesha.recaptcha.ReCaptchaFactory; ticbox.City; ticbox.LookupMaster; ticbox.ProfileItem" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="ticbox"/>
    <title><g:message code="app.register.respondent.label" /></title>
</head>
<body >
<div class="module ">
    <div class="module-header">
        <div class="title"><g:message code="app.register.respondent.label" /></div>
    </div>

    <div class="module-content">
        <g:form name="registerForm" action="register" class="form-horizontal" role="form">
            <g:hiddenField name="userType" value="respondent"/>
            <g:hiddenField name="referrer" value="${ref}"/>
            <fieldset>
                <div class="form-group">
                    <label for="username" class="col-sm-3 control-label"><g:message code="app.username.label"/></label>
                    <div class="col-sm-4"><g:textField name="username" value="${username}" class="form-control"/></div>
                </div>
                <div class="form-group">
                    <label for="email" class="col-sm-3 control-label"><g:message code="app.email.label"/></label>
                    <div class="col-sm-4"><g:textField name="email" value="${email}" class="form-control"/></div>
                </div>
                <div class="form-group">
                    <label for="password" class="col-sm-3 control-label"><g:message code="app.password.label"/></label>
                    <div class="col-sm-4"><g:passwordField name="password" class="form-control"/></div>
                </div>
                <div class="form-group">
                    <label for="passwordconfirm" class="col-sm-3 control-label"><g:message code="app.passwordconfirm.label"/></label>
                    <div class="col-sm-4"><g:passwordField name="passwordconfirm" class="form-control"/></div>
                </div>
                %{--<g:each in="${profileItemList}" var="profileItem">--}%
                    %{--<div class="form-group">--}%
                        %{--<label for="${profileItem.code}" class="col-sm-3 control-label">--}%
                            %{--${profileItem.label}--}%
                            %{--<g:if test="${profileItem.unit}">--}%
                                %{--(${profileItem.unit})--}%
                            %{--</g:if>--}%
                        %{--</label>--}%
                        %{--<div class="col-sm-8">--}%
                            %{--<g:if test="${profileItem.type == ticbox.ProfileItem.TYPES.STRING}">--}%
                                %{--<g:if test="${profileItem.row > 1}">--}%
                                    %{--<g:textArea name="${profileItem.code}" rows="${profileItem.row}" cols="30" maxlength="${profileItem.max}" placeholder="${profileItem.placeHolder}" class="form-control"></g:textArea>--}%
                                %{--</g:if>--}%
                                %{--<g:else>--}%
                                    %{--<input name="${profileItem.code}" type="text" maxlength="${profileItem.max}" placeholder="${profileItem.placeHolder}" class="form-control" style="min-width: 40%; width: auto;"/>--}%
                                %{--</g:else>--}%
                            %{--</g:if>--}%
                            %{--<g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.DATE}">--}%
                                %{--<input name="${profileItem.code}" type="text" class="datePicker form-control" placeholder="${message([code: 'app.date.format.input', default: 'dd/MM/yyyy'])}" style="min-width: 40%; width: auto;">--}%
                            %{--</g:elseif>--}%
                            %{--<g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.NUMBER}">--}%
                                %{--<input name="${profileItem.code}" type="text" class="num form-control" data-max="${profileItem.max}" data-min="${profileItem.min}" placeholder="${profileItem.min && profileItem.max ? "${profileItem.min} - ${profileItem.max}" : ''}" style="text-align:right;min-width: 40%; width: auto;">--}%
                            %{--</g:elseif>--}%
                            %{--<g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.LOOKUP}">--}%
                                %{--<g:select name="${profileItem.code}" from="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" optionKey="key" optionValue="value" class="form-control" style="min-width: 40%; width: auto;"/>--}%
                            %{--</g:elseif>--}%
                            %{--<g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.CHOICE}">--}%
                                %{--<g:if test="${profileItem.componentType == ticbox.ProfileItem.COMPONENT_TYPES.CHK_BOX}">--}%
                                    %{--<g:if test="${profileItem.items}">--}%
                                        %{--<g:each in="${profileItem.items}" var="item">--}%
                                            %{--<label class="checkbox">--}%
                                                %{--<input type="checkbox" name="${profileItem.code}" value="${item}"> ${"$item"}--}%
                                            %{--</label>--}%
                                        %{--</g:each>--}%
                                    %{--</g:if>--}%
                                    %{--<g:elseif test="${profileItem.lookupFrom}">--}%
                                        %{--<g:each in="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" var="item">--}%
                                            %{--<label class="checkbox">--}%
                                                %{--<input type="checkbox" name="${profileItem.code}" value="${item.key}"> ${"$item.value"}--}%
                                            %{--</label>--}%
                                        %{--</g:each>--}%
                                    %{--</g:elseif>--}%
                                %{--</g:if>--}%
                                %{--<g:elseif test="${profileItem.componentType == ticbox.ProfileItem.COMPONENT_TYPES.SELECT}">--}%
                                    %{--<g:if test="${profileItem.items}">--}%
                                        %{--<g:if test="${profileItem.multiple}">--}%
                                            %{--<g:select name="${profileItem.code}" from="${profileItem.items}"  multiple="true" class="form-control" style="min-width: 40%; width: auto;"/>--}%
                                        %{--</g:if>--}%
                                        %{--<g:else> --}%%{--this is stupid!!!!--}%
                                            %{--<g:select name="${profileItem.code}" from="${profileItem.items}" class="form-control" style="min-width: 40%; width: auto;"/>--}%
                                        %{--</g:else>--}%
                                    %{--</g:if>--}%
                                    %{--<g:elseif test="${profileItem.lookupFrom}">--}%
                                        %{--<g:if test="${profileItem.multiple}">--}%
                                            %{--<g:select name="${profileItem.code}" from="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" optionKey="key" optionValue="value" multiple="true" class="form-control" style="min-width: 40%; width: auto;"/>--}%
                                        %{--</g:if>--}%
                                        %{--<g:else> --}%%{--this is stupid!!!!--}%
                                            %{--<g:if test="${profileItem.code=="PI_PROVINCE001"}" >--}%
                                                %{--<g:select name="${profileItem.code}" from="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" optionKey="key" optionValue="value" class="form-control" style="min-width: 40%; width: auto;" onchange="changeIt(this)"/>--}%
                                            %{--</g:if>--}%
                                            %{--<g:elseif test="${profileItem.code=="PI_CITY001"}" >--}%
                                                %{--<g:select name="${profileItem.code}" from="" optionKey="key" optionValue="value" class="form-control" style="min-width: 40%; width: auto;" />--}%
                                            %{--</g:elseif>--}%
                                            %{--<g:else>--}%
                                                %{--<g:select name="${profileItem.code}" from="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" optionKey="key" optionValue="value" class="form-control" style="min-width: 40%; width: auto;"/>--}%
                                            %{--</g:else>--}%
                                        %{--</g:else>--}%
                                    %{--</g:elseif>--}%
                                %{--</g:elseif>--}%
                                %{--<g:elseif test="${profileItem.componentType == ticbox.ProfileItem.COMPONENT_TYPES.RADIO}">--}%
                                    %{--<g:if test="${profileItem.items}">--}%
                                        %{--<g:each in="${profileItem.items}" var="item">--}%
                                            %{--<label class="radio">--}%
                                                %{--<input type="radio" name="${profileItem.code}" value="${item}"> ${"$item"}--}%
                                            %{--</label>--}%
                                        %{--</g:each>--}%
                                    %{--</g:if>--}%
                                    %{--<g:elseif test="${profileItem.lookupFrom}">--}%
                                        %{--<g:each in="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" var="item">--}%
                                            %{--<label class="radio">--}%
                                                %{--<input type="radio" name="${profileItem.code}" value="${item.key}"> ${"$item.value"}--}%
                                            %{--</label>--}%
                                        %{--</g:each>--}%
                                    %{--</g:elseif>--}%
                                %{--</g:elseif>--}%
                            %{--</g:elseif>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                %{--</g:each>--}%
                %{--<%--}%
                    %{--ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LcX7_0SAAAAAENhL5WPKwRbZPi7UusrWcCr_fUp", "6LcX7_0SAAAAAOSBotMxA8-igpdWpclgrKhQfqGz", false);--}%
                    %{--out.print(c.createRecaptchaHtml(null, null));--}%
                %{--%>--}%

                <div class="form-group">
                    <div class="col-sm-8 col-sm-offset-3">
                        <script type="text/javascript"
                                src="https://www.google.com/recaptcha/api/challenge?k=6LcX7_0SAAAAAENhL5WPKwRbZPi7UusrWcCr_fUp">
                        </script>

                        <noscript>
                            <iframe src="https://www.google.com/recaptcha/api/noscript?k=6LcX7_0SAAAAAENhL5WPKwRbZPi7UusrWcCr_fUp"
                                    height="300" width="500" frameborder="0"></iframe><br>
                            <textarea name="recaptcha_challenge_field" rows="3" cols="40">
                            </textarea>
                            <input type="hidden" name="recaptcha_response_field"
                                   value="manual_challenge">
                        </noscript>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-8 col-sm-offset-3"><p class="muted"><g:message code="app.register.disclaimer.message" args="${[request.getContextPath()]}"/></p></div>
                </div>
                <div class="form-group">
                    <div class="col-sm-8 col-sm-offset-3">
                        <p>
                            <g:submitButton name="submit" value="${g.message(code:'app.register.label')}" class="btn btn-lg btn-green"/>
                            <button type="reset" name="reset" class="btn btn-lg btn-light-oak">${g.message(code:'app.reset.label')}</button>
                        </p>
                    </div>

                </div>
            </fieldset>
        </g:form>
    </div>
</div>
<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">
    $(document).ready(function() {
        loadIt();

        $('#registerForm').validate({
            rules: {
                username: {
                    required: true,
                    minlength: 5
                },
                email: {
                    email: true,
                    required: true,
                    minlength: 5
                },
                password: {
                    required: true,
                    minlength: 5
                },
                passwordconfirm: {
                    required: true,
                    minlength: 5,
                    equalTo: password
                }
            }
        });

        $('.num').each(function() {
            $(this).rules('add', {
                number: true,
                range: [$(this).attr('data-min'), $(this).attr('data-max')]
            });
        });

        $('.datePicker').each(function() {
            $(this).rules('add', {
                dateITA: true
            });
        });

    });

    function changeIt(selectObj) {
        var val = selectObj.options[selectObj.selectedIndex].value;
        var elmtCity= $('#PI_CITY001')
        if(elmtCity) {
            elmtCity.find('option').remove().end();
            jQuery.getJSON('${request.contextPath}/home/getCity', {province: val}, function (cities) {
//                var temp = cities;
                jQuery.each(cities, function (i, item) {
                    var option = document.createElement("option");
                    option.text = item.label;
                    option.value = item.code;
                    elmtCity.append(option);
                });
            });
        }
//                                            }

    }
    function loadIt() {

        var elmtProvince=document.getElementById("PI_PROVINCE001");
        var val = elmtProvince.options[elmtProvince.selectedIndex].value;
        var elmtCity= $('#PI_CITY001')
        if(elmtCity) {
            elmtCity.find('option').remove().end();
            jQuery.getJSON('${request.contextPath}/home/getCity', {province: val}, function (cities) {

                jQuery.each(cities, function (i, item) {
                    var option = document.createElement("option");
                    option.text = item.label;
                    option.value = item.code;
                    elmtCity.append(option);
                });
            });
        }

    }

</script>
</body>
</html>