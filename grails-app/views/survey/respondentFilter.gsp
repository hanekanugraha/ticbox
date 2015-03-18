<%--
  Created by IntelliJ IDEA.
  User: arnold
  Date: 3/24/13
  Time: 11:48 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="ticbox.Survey; ticbox.ProfileItem; ticbox.LookupMaster" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="surveyor"/>
    <title></title>
    <style type="text/css">
        #filterForm .well {
            background-color: #ffffff;
            border-color: #7F9B09;
        }

        /*#filterForm .control-group {*/
            /*margin-bottom: 10px;*/
        /*}*/

        #filterForm .profile-item-container {
            /*-webkit-box-shadow: 0 6px 5px -5px #a0a0a0*//*#7F9B09*//*;*/
            /*-moz-box-shadow: 0 6px 5px -5px#a0a0a0*//*#7F9B09*//*;*/
            /*box-shadow: 0 6px 5px -5px #a0a0a0*//*#7F9B09*//*;*/
            /*margin-bottom: 10px;*/
            padding: 10px 0 0 0;
        }

        #filterAddForm {
            background-color: gainsboro;
            border-radius: 6px 6px 6px 6px;
            width: auto;
            padding: 10px 0 5px 0;
        }

        /*#filterForm.form-horizontal .controls {*/
            /*margin-right: 25px;*/
        /*}*/

        .prettycheckbox label {
            font-weight: normal;
        }

    </style>
</head>

<body>
    <div id="menuNavPanelContent">
    </div>

    <div class="module">
        %{--<div class="line line-centered">--}%
        <div class="module-header">
            <div class="title">Choose Your Survey Type</div>
        </div>

        <div class="module-content">
            <div class="row" style="margin-top: 10px; padding: 0 20%; text-align: center">
                <div class="col-xs-6 enableTooltip" id="freeSurvey" style="margin-bottom: 10px;">
                    %{--<div id="freeSurvey" style="text-align: center">--}%
                        <label class="img-radio" for="freeSurveyChk" style="max-width: 100%">
                            <input name="surveyType" data-toggle="tooltip" data-placement="bottom" type="radio"
                                   class="surveyType" id="freeSurveyChk"
                                   data-label="<g:message code="survey.type.free.label"/>" value="${Survey.SURVEY_TYPE.FREE}">
                            <img src="../images/ticbox/free_survey_140.png" class="img-circle img-responsive">
                            <div>
                                <span class="img-label"><g:message code="survey.type.free.label"/></span>
                                <i class="glyphicon glyphicon-question-sign" style="text-align: left" data-toggle="tooltip" title="
                                    Write surveys with various question types such as single or multiple choices, star rating, scale rating and free text.
                                    Upload images into any Q or A or link a youtube video. Once published, this survey will be accessible
                                    by anyone from our reliable communities.
                                    For a more focused respondents, please use Easy Survey."
                                   id='freeSurveyInfo'></i>
                            </div>
                        </label>

                    %{--</div>--}%
                </div>
                <div class="col-xs-6 enableTooltip" id="easySurvey" style="margin-bottom: 10px;">
                    %{--<div id="easySurvey" style="text-align: center">--}%
                        <label class="img-radio" for="easySurveyChk" style="max-width: 100%">
                            <input name="surveyType" data-toggle="tooltip" data-placement="bottom" type="radio"
                               class="surveyType" id="easySurveyChk"
                               data-label="<g:message code="survey.type.easy.label"/>" value="${Survey.SURVEY_TYPE.EASY}">
                            <img src="../images/ticbox/easy_survey_140.png" class="img-circle img-responsive">
                            <div>
                                <span class="img-label"><g:message code="survey.type.easy.label"/></span>
                                <i class="glyphicon glyphicon-question-sign" data-toggle="tooltip" title="
                            Have a survey where you need a specific, targeted audience to respond?
                            You can do this just easily by using our various choices of filter.
                            Once published, your survey will be accessible only by respondents suitable with your target market."
                                   id='easySurveyInfo'></i>
                            </div>
                        </label>
                    %{--</div>--}%
                </div>
            </div>


        </div>
        <div class="module-header">
            <div class="title">Choose Your Completion Type</div>
        </div>
        <div class="module-content">
            <form id="filterCompletionByDate" class="form-horizontal">
            <!-- completion by time -->
                <div class="row" style="margin-top: 10px; padding: 0 20%; text-align: justify">

                        <!-- completion filter -->
                        <div class="profile-item-container form-group" style="position: relative" label="Completion by Time" type="DATE">
                            <!--i class="remove-filter glyphicon glyphicon-remove clickable" style="position: absolute; top: 5px; right: 7px;"></i-->
                            <div class="coll-sm-1 form-inLine">
                                <input id="completionByTimeChk" name="completionByTimeChk" class="check-item prettyChk form-control"
                                       type="checkbox" style="width: auto">
                            </div>
                            <label class="col-sm-3 control-label">Time</label>

                            <div class="col-sm-9 form-inline" style="font-weight: normal">
                                <input id="completionDateFrom" name="completionDateFrom" class="filter-value-from datePicker form-control"
                                       type="text" placeholder="Start Date" style="width: auto"
                                       value="${survey.completionDateFrom}">
                                -
                                <input id="completionDateTo" name="completionDateTo" class="filter-value-to datePicker form-control"
                                       type="text" placeholder="End Date" style="width: auto"
                                       value="${survey.completionDateTo}">

                            </div>
                        </div>
                </div>
            <!--/form-->
            <!--/div-->
            <!-- Completion by respondent -->
            <div class="row" style="margin-top: 10px; padding: 0 20%; text-align: justify">
                <!--form id="filterCompletionByTtlRespondent" class="form-horizontal"-->
                    <div class="profile-item-container form-group" style="position: relative" label="Completion by Total Respondent" type="NUMBER">
                        <div class="coll-sm-1 form-inLine">
                            <input id="completionByTtlRespondentChk" name="completionByTtlRespondentChk" class="check prettyChk form-control"
                                   type="checkbox">
                        </div>
                        <label class="col-sm-3 control-label">Total Respondent</label>

                        <div class="col-sm-9 form-inline" style="font-weight: normal">
                            <input id="completionByTtlRespondent" name="completionByTtlRespondent" class="filter-value form-control"
                                   type="number" placeholder="0" style="width: auto"

                                   value="${survey.ttlRespondent}">
                            <span id="errmsg" style="display: none;">Digits Only</span>
                        </div>
                    </div>
                <!--/form-->
            </div>
            </form>
        </div>

        <div id="filterHeader" class="module-header">
            <div class="title">Define Respondent Filter</div>
        </div>

        <div id="filterContent" class="module-content">
            <form id="filterForm" class="form-horizontal">


            </form>

            <form id="filterAddForm" class="form-inline" style="text-align: center !important">
                <div class="form-group" style="margin: 10px 0 15px 0">
                    <label class="" for="respondentFilterComponents">Add Filter</label>

                    <select id="respondentFilterComponents" class="form-control" style="display: inline; width: auto">
                        <g:each in="${profileItems}" var="profileItem">
                            <%--g:if test="${profileItem.code!="PI_CITY001"}" --%>
                                <option value="${profileItem.code}">${profileItem.label}</option>
                            <!--/g:if-->
                        </g:each>
                    </select>

                    <button id="addFilterBtn" class="btn btn-default" type="button" >
                        <i class="glyphicon glyphicon-plus"></i>
                    </button>
                </div>
            </form>
        </div>

        <div id="buttonBarHeader" class="module-header"></div>
        <div id="buttonBarContent" class="module-content">
            <button class="btn btn-sm btn-light-oak link" href="${request.contextPath}/survey/" type="button" style="margin: 3px 0">
                <g:message code="label.button.back" default="Back"/>
            </button>
            <%--button id="submitFilterBtn" class="btn btn-sm btn-green" type="button" style="margin: 3px 0">
                <g:message code="label.button.save" default="Save"/>
            </button--%>
            <button id="nextAndSubmitFilterBtn" class="btn btn-sm btn-blue-trust link" style="margin: 3px 0">
                <g:message code="label.button.next" default="Next"/>
            </button>
            <%--button id="hulabtn" class="btn btn-sm btn-blue-trust link" href="${request.contextPath}/survey/surveyGenerator" style="margin: 3px 0">
                <g:message code="label.button.next" default="hula"/>
            </button--%>
        </div>

        <form id="filterTemplates" class="form-horizontal" style="display: none">
            <g:each in="${profileItems}" var="profileItem">
                <div class="profile-item-container form-group" code="${profileItem.code}" type="${profileItem.type}" label="${profileItem.label}" style="position: relative">
                    <i class="remove-filter glyphicon glyphicon-remove clickable" style="position: absolute; top: 5px; right: 7px;"></i>
                    <label class="col-sm-2 control-label" for="${profileItem.code}">${profileItem.label}</label>

                    <div class="col-sm-9 form-inline" style="font-weight: normal">
                        <g:if test="${profileItem.type == ticbox.ProfileItem.TYPES.STRING}">
                            <g:if test="${profileItem.row > 1}">
                                <textArea class="filter-value form-control" id="${profileItem.code}" name="${profileItem.code}"
                                          rows="${profileItem.row}" cols="30" maxlength="${profileItem.max}"
                                          placeholder="${profileItem.placeHolder}"
                                          style="width: 85%; resize: none"></textArea>
                            </g:if>
                            <g:else>
                                <input class="filter-value form-control" id="${profileItem.code}" name="${profileItem.code}" type="text"
                                       class="" max="${profileItem.max}" placeholder="${profileItem.placeHolder}"/>
                            </g:else>
                        </g:if>
                        <g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.DATE}">
                            <input id="${profileItem.code}" name="${profileItem.code}" type="text" style="width: auto"
                                   class="filter-value-from datePicker form-control" placeholder="from"> - <input type="text" style="width: auto"
                                                                                                     class="filter-value-to datePicker form-control"
                                                                                                     placeholder="to">
                        </g:elseif>
                        <g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.NUMBER}">
                            <input class="filter-value-from form-control" id="${profileItem.code}" name="${profileItem.code}" type="text" style="width: auto"
                                   placeholder="from"> - <input class="filter-value-to form-control" type="text" style="width: auto" id="${profileItem.code}_1"
                                                                placeholder="to"> ${profileItem.unit}
                        </g:elseif>
                        <g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.LOOKUP}">
                            <g:each in="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" var="item">
                            %{--<label class="checkbox">
                                        <input id="${profileItem.code}_${item.key}" class="check-item" type="checkbox" name="${profileItem.code}" value="${item.key}" label="${item.value}"> ${item.value}
                                    </label>--}%
                                <input id="${profileItem.code}_${item.key}" class="check-item prettyChk form-control" type="checkbox"
                                       data-label="${item.value}" name="${profileItem.code}" value="${item.key}"
                                       label="${item.value}">
                            </g:each>
                        </g:elseif>

                        <g:elseif test="${profileItem.type == ticbox.ProfileItem.TYPES.CHOICE}">
                            <g:if test="${profileItem.items}">
                                <g:each in="${profileItem.items}" var="item">
                                %{--<label class="checkbox">
                                            <input id="${profileItem.code}_${item}" class="check-item" type="checkbox" name="${profileItem.code}" value="${item}"> ${item}
                                        </label>--}%

                                        <input id="${profileItem.code}_${item}" class="check-item prettyChk form-control" type="checkbox"
                                           data-label="${item}" name="${profileItem.code}" value="${item}">

                                </g:each>
                            </g:if>
                            <g:elseif test="${profileItem.lookupFrom}">
                                <%--g:if test="${profileItem.code=="PI_PROVINCE001"}" --%>
                                    <g:each in="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" var="item">
                                    %{--<label class="checkbox">
                                                <input id="${profileItem.code}_${item.key}" class="check-item" type="checkbox" name="${profileItem.code}" value="${item.key}" label="${item.value}"> ${item.value}
                                            </label>--}%

                                        <input id="${profileItem.code}_${item.key}" class="check-item prettyChk form-control" type="checkbox"
                                               data-label="${item.value}" name="${profileItem.code}" value="${item.key}"
                                              <%-- label="${item.value}" onchange="loadCity()"--%>
                                               label="${item.value}">
                                        <!--br/-->

                                    </g:each>

                                    <%--div class="profile-item-container form-inline" code="PI_CITY001" type="CHOICE" label="City" style="position: relative"--%>
                                    %{--<i class="remove-filter glyphicon glyphicon-remove clickable" style="position: absolute; top: 5px; right: 7px;"></i>--}%
                                    <%--label class="col-sm-2 control-label" for="PI_CITY001">City</label>
                                    <div class="col-sm-9 form-inline" style="font-weight: normal">
                                        <select name="listCity" size=8 class="listCity" multiple>
                                            <option name=one value=one> one </option>
                                            <option name=two value=two> two </option>
                                            <option name=three value=three> three </option>
                                            <option name=four value=four> four </option>
                                        </select>
                                        <input type="button" value="Add &gt;&gt;" style="width:80px" onclick="addCity()">
                                        <input type="button" value="Remove &lt;&lt;" style="width:80px" onclick="removeCity()">

                                        <select name="selectedCity" class="selectedCity" size=8 multiple>
                                            <option name=one value=one> one </option>
                                            <option name=two value=two> two </option>
                                            <option name=three value=three> three </option>
                                            <option name=four value=four> four </option>
                                        </select>

                                    </div--%>
                                <!--/g:if-->
                                <%--g:elseif test="${profileItem.code!="PI_CITY001"}">
                                    <g:each in="${LookupMaster.findByCode(profileItem.lookupFrom)?.values}" var="item">
                                %{--<label class="checkbox">
                                            <input id="${profileItem.code}_${item.key}" class="check-item" type="checkbox" name="${profileItem.code}" value="${item.key}" label="${item.value}"> ${item.value}
                                        </label>--}%

                                        <input id="${profileItem.code}_${item.key}" class="check-item prettyChk form-control" type="checkbox"
                                           data-label="${item.value}" name="${profileItem.code}" value="${item.key}"
                                           label="${item.value}" >

                                    </g:each>
                                </g:elseif--%>
                            </g:elseif>

                        </g:elseif>
                    </div>
                </div>
            </g:each>
        </form>

    </div>

    <!-- validate filter modal -->
    <div id="validate-filter-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="validateFilterLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="validateFilterLabel" class="modal-title">
                    Filter Validation
                </span>
            </div>
            <div class="modal-body">
                <g:form name="validateFilterForm" role="form">
                    <div class="well">
                        <p><b><span id="labelHeaderForm" name="labelHeaderForm" text="Are you not answering the question?"/></b></p>
                        <span id="labelText" name="labelText" text="Please answer the question before you go to the next step."/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">OK</button>
            </div>
        </div>
    </div>
</div>

    <script type="text/javascript">

        $('#freeSurveyInfo').tooltip({'placement': 'right','content':'text', 'container':'body'});
        $('#easySurveyInfo').tooltip({'placement': 'right','content':'text', 'container':'body'});

        //called when key is pressed in textbox
        $("#completionByTtlRespondent").keypress(function (e) {
            //if the letter is not digit then display error and don't type anything
            if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
                //display error message
                //$("#errmsg").html("Digits Only").show().fadeOut("slow");
                return false;
            }
        });

        $("#PI_HEIGHT001").keypress(function (e) {
            if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {return false;}
        });

        $("#PI_HEIGHT001_1").keypress(function (e) {
            if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {return false;}
        });
        $("#PI_WEIGHT001").keypress(function (e) {
            if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {return false;}
        });

        $("#PI_WEIGHT001_1").keypress(function (e) {
            if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {return false;}
        });

        jQuery(function () {

            jQuery('#surveyorProfileContent').addClass('out');
            jQuery('#surveyInfoContainer').addClass('in');
            <!-- jQuery('#surveyInfoAccordion').show(); -->
            <!-- jQuery('#surveyInfoAccordion').hide(); -->

            jQuery.getJSON('${request.contextPath}/survey/getSurveySummary', {}, function (data) {
                if (data) {
                    surveySummary = data;

                    jQuery('.total-charge').html(parseFloat(surveySummary.chargePerRespondent) * parseFloat(surveySummary.totalRespondent));
                    jQuery('.charge-per-respondent').html(surveySummary.chargePerRespondent);
                    jQuery('.total-respondents').html(surveySummary.totalRespondent);
                }
            });

            jQuery('input.surveyType').change(function () {
                if (jQuery(this).is(':checked')) {
                    var val = jQuery(this).val();

                    if (val == '${Survey.SURVEY_TYPE.FREE}') {
    //                    jQuery('#filterForm').hide();
    //                    jQuery('#filterAddForm').hide();
                        jQuery('#filterHeader').hide();
                        jQuery('#filterContent').hide();
                    } else if (val == '${Survey.SURVEY_TYPE.EASY}') {
    //                    jQuery('#filterForm').show();
    //                    jQuery('#filterAddForm').show();
                        jQuery('#filterHeader').show();
                        jQuery('#filterContent').show();
                    }
                }
            });

            jQuery('input.surveyType[value="${survey.type}"]').prop('checked', true).trigger('change');
            
            if('${survey.completionDateTo}'==null || '${survey.completionDateTo}'=='') {
                jQuery('#completionDateFrom').prop('disabled', true).trigger('change');
                jQuery('#completionDateTo').prop('disabled', true).trigger('change');
            } else {
                jQuery('#completionByTimeChk').prop('checked', true).trigger('change');
            }

            if('${survey.ttlRespondent}'>0 || '${survey.ttlRespondent}'==null) {
                jQuery('#completionByTtlRespondentChk').prop('checked', true).trigger('change');
            } else {
                jQuery('#completionByTtlRespondent').prop('disabled', true).trigger('change');
            }

            jQuery('#completionByTimeChk').change(function() {
                if(jQuery(this).is(':checked')) {
                    $("#completionDateFrom").attr('disabled', false);
                    $("#completionDateTo").attr("disabled", false);
                }
                else {
                    $("#completionDateFrom").attr('disabled', true);
                    $("#completionDateTo").attr('disabled', true);
                }
            });

            jQuery('#completionByTtlRespondentChk').change(function() {
                if(jQuery(this).is(':checked')) {

                    $("#completionByTtlRespondent").attr('disabled', false);
                }
                else {

                    $("#completionByTtlRespondent").attr('disabled', true);
                }
            });

            jQuery('#addFilterBtn').click(function () {

                var filterComponentCode = jQuery('#respondentFilterComponents').val();

                populateFilterComponent(filterComponentCode);

            });

            var submitFilterItems = function() {
                var filterItems = [];

                var form = $('#validateFilterForm');
                var isCompletionByTime = jQuery('#completionByTimeChk').is(':checked');
                var isCompletionByTtlResp = jQuery('#completionByTtlRespondentChk').is(':checked');

                if(!isCompletionByTime && !isCompletionByTtlResp) {
                    $('#labelHeaderForm', form).text('Choose Completion');
                    $('#labelText', form).text('Please choose completion type for your survey.');
                    $('#validate-filter-modal').modal('show');

                    return false;
                }

                <%-- completion date --%>
                var compDateFrom = jQuery('#completionDateFrom').datepicker('getDate');
                var compDateTo   = jQuery('#completionDateTo').datepicker('getDate');
                compDateFrom = compDateFrom ? $.datepicker.formatDate( 'mm/dd/yy', compDateFrom) : undefined;
                compDateTo = compDateTo ? $.datepicker.formatDate( 'mm/dd/yy', compDateTo) : undefined;

                var ttlRespondent = jQuery('#completionByTtlRespondent').val();



                if(isCompletionByTime) {
                    if(!validateCompletionDate(compDateFrom, compDateTo))
                        return false;
                }
                else {
                    compDateFrom = '';
                    compDateTo = '';
                }


                if (!isCompletionByTtlResp) {
                    ttlRespondent = 0
                } else if(ttlRespondent<=0) {


                    $('#labelHeaderForm', form).text('Completion By Total Respondent is Mandatory');
                    $('#labelText', form).text('Please insert total respondent for your survey.');
                    $('#validate-filter-modal').modal('show');

                    return false;
                }

//                if(checkCompletion(compDateFrom,compDateTo)) {

                    if (jQuery('#easySurveyChk').is(':checked')) {
                        jQuery('#filterForm').find('.profile-item-container').each(function () {

                            var filterItem = {};

                            filterItem['code'] = jQuery(this).attr('code');
                            filterItem['type'] = jQuery(this).attr('type');
                            filterItem['label'] = jQuery(this).attr('label');

                            switch (filterItem['type']) {

                                case '${ProfileItem.TYPES.STRING}' :

                                    filterItem['val'] = jQuery('.filter-value', this).val();

                                    break;

                                case '${ProfileItem.TYPES.NUMBER}' :

                                    var valFrom = jQuery('.filter-value-from', this).val();
                                    var valTo = jQuery('.filter-value-to', this).val();

                                    filterItem['valFrom'] = valFrom ? parseInt(valFrom) : 0;
                                    filterItem['valTo'] =  valTo ? parseInt(valTo) : 0;

                                    break;

                                case '${ProfileItem.TYPES.CHOICE}' :
                                    filterItem['checkItems'] = [];
                                    jQuery('input.check-item:checked', this).each(function () {
                                        if (jQuery(this).attr('label')) {
                                            filterItem['checkItems'].push({key: jQuery(this).val(), value: jQuery(this).attr('label')});
                                        } else {
                                            filterItem['checkItems'].push(jQuery(this).val());
                                        }
                                    });

                                    break;

                                case '${ProfileItem.TYPES.LOOKUP}' :
                                    filterItem['checkItems'] = [];
                                    jQuery('input.check-item:checked', this).each(function () {
                                        filterItem['checkItems'].push({key: jQuery(this).val(), value: jQuery(this).attr('label')});
                                    });

                                    break;

                                case '${ProfileItem.TYPES.DATE}' :

                                    var dateFrom = jQuery('.filter-value-from', this).datepicker('getDate');
                                    var dateTo = jQuery('.filter-value-to', this).datepicker('getDate');

                                    dateFrom = dateFrom ? $.datepicker.formatDate( 'mm/dd/yy', dateFrom) : undefined;
                                    dateTo = dateTo ? $.datepicker.formatDate( 'mm/dd/yy', dateTo) : undefined;

                                    //filterItem['valFrom'] = dateFrom ? parseInt(dateFrom) : 0;
                                    //filterItem['valTo'] = dateTo ? parseInt(dateTo) : 0;
                                    filterItem['valFrom'] = dateFrom ? dateFrom : undefined;
                                    filterItem['valTo'] = dateTo ? dateTo : undefined;

                                    break;

                                default :

                                    break;

                            }

                            filterItems.push(filterItem);

                        });

                    }

                    var filterItemsJSON = JSON.stringify(filterItems);

                    jQuery.getJSON('${request.contextPath}/survey/submitRespondentFilter', {filterItemsJSON: filterItemsJSON, compDateFrom: compDateFrom, compDateTo:compDateTo,
                                                                                            ttlRespondent:ttlRespondent, surveyType: jQuery('input.surveyType:checked').val()}, function (data) {

                        //alert('Submitted');

                        loadRespondentFilter(data);
                        window.location = "${request.contextPath}/survey/surveyGenerator";
                    });
//                }
            };

                jQuery('#nextAndSubmitFilterBtn').click(submitFilterItems);

                jQuery('#submitFilterBtn').click(submitFilterItems);

                if ('${ticbox.Survey.SURVEY_TYPE.EASY}' == '${survey.type}') {
                    jQuery.getJSON('${request.contextPath}/survey/getRespondentFilter', {}, function (respondentFilter) {

                        jQuery.each(respondentFilter, function (idx, filter) {
                            populateFilterComponent(filter.code, filter)
                        });

                        loadRespondentFilter(respondentFilter);

                    });
                }


        });

        function populateFilterComponent(filterComponentCode, filter) {
            var template = jQuery('#filterTemplates').find('.form-group[code="' + filterComponentCode + '"]');

            if (template.length > 0) {
                jQuery('#filterForm').append(template);

                jQuery('.remove-filter', template).click(function () {
                    jQuery(this).parent().appendTo(jQuery('#filterTemplates'));
                });

                if (filter) {
                    switch (filter.type) {

                        case '${ProfileItem.TYPES.STRING}' :

                            jQuery('.filter-value', template).val(filter.val);

                            break;

                        case '${ProfileItem.TYPES.NUMBER}' :

                            jQuery('.filter-value-from', template).val(filter.valFrom);
                            jQuery('.filter-value-to', template).val(filter.valTo);

                            break;

                        case '${ProfileItem.TYPES.CHOICE}' :
                            var filter_ = filter;
                            jQuery('input.check-item', template).each(function () {
                                var chkBox = this;
                                jQuery.each(filter_.checkItems, function (idx, item) {
                                    if (item instanceof Object) {
                                        if (jQuery(chkBox).val() == item.key) {
                                            //jQuery(chkBox).prop('checked', true);
                                            jQuery(chkBox).parent().find('a').trigger('click');
                                        }
                                    } else {
                                        if (jQuery(chkBox).val() == item) {
                                            //jQuery(chkBox).prop('checked',true);
                                            jQuery(chkBox).parent().find('a').trigger('click');
                                        }
                                    }
                                });
                            })/*.prettyCheckable()*/;

                            break;

                        case '${ProfileItem.TYPES.LOOKUP}' :
                            var filter_ = filter;
                            jQuery('input.check-item', template).each(function () {
                                var chkBox = this;
                                jQuery.each(filter_.checkItems, function (idx, item) {
                                    if (item instanceof Object) {
                                        if (jQuery(chkBox).val() == item.key) {
                                            //jQuery(chkBox).prop('checked', true);
                                            jQuery(chkBox).parent().find('a').trigger('click');
                                        }
                                    } else {
                                        if (jQuery(chkBox).val() == item) {
                                            //jQuery(chkBox).prop('checked', true);
                                            jQuery(chkBox).parent().find('a').trigger('click');
                                        }
                                    }
                                });
                            })/*.prettyCheckable()*/;

                            break;

                        case '${ProfileItem.TYPES.DATE}' :

                            jQuery('.filter-value-from', template).val(filter.valFrom);
                            jQuery('.filter-value-to', template).val(filter.valTo);

                            break;

                        default :

                            break;

                    }
                }
            }
        }

        function loadRespondentFilter(respondentFilter) {

            jQuery('.filter-details-container').empty();

            if (respondentFilter) {

                jQuery.each(respondentFilter, function (idx, filter) {

                    var filterContent = null;

                    switch (filter.type) {

                        case '${ProfileItem.TYPES.STRING}' :

                            filterContent = jQuery('<div style="margin-left: 15px"></div>').append(filter.val);

                            break;

                        case '${ProfileItem.TYPES.NUMBER}' :

                            filterContent = jQuery('<div style="margin-left: 15px"></div>').append(filter.valFrom + ' - ' + filter.valTo);

                            break;

                        case '${ProfileItem.TYPES.CHOICE}' :

                            if(filter)
                            filterContent = jQuery('<div style="margin-left: 15px"></div>');
                            var ul = jQuery('<ul></ul>');

                            jQuery.each(filter.checkItems, function (idx, item) {
                                if (item instanceof Object) {
                                    ul.append(jQuery('<li></li>').append(item.value));
                                } else {
                                    ul.append(jQuery('<li></li>').append(item));
                                }
                            });

                            /*if(filter.code=='PI_PROVINCE001'){
                                ;
                            }*/

                            filterContent.append(ul);

                            break;

                        case '${ProfileItem.TYPES.LOOKUP}' :

                            filterContent = jQuery('<div style="margin-left: 15px"></div>');
                            var ul = jQuery('<ul></ul>');

                            jQuery.each(filter.checkItems, function (idx, item) {
                                ul.append(jQuery('<li></li>').append(item.value));
                            });

                            filterContent.append(ul);

                            break;

                        case '${ProfileItem.TYPES.DATE}' :

                            filterContent = jQuery('<div style="margin-left: 15px"></div>').append(filter.valFrom + ' - ' + filter.valTo);

                            break;

                        default :

                            break;

                    }

                    jQuery('.filter-details-container').append(jQuery('<div class="line"><div>')
                            .append(jQuery('<label></label>').append(jQuery('<strong></strong>').append(filter.label + ' : ')))
                            .append(filterContent)
                    );

                });

            } else {
                //TODO no survey fetched
            }
        }

        function loadCity() {
            //alert("change")
        }

        function validateCompletionDate(compDateFrom, compDateTo) {
            var returnBoolean = true;
            var form = $('#validateFilterForm');


            if(compDateFrom==undefined||compDateTo==undefined) {
                $('#labelHeaderForm', form).text('Completion Date is Mandatory');
                $('#labelText', form).text('Please insert Start Date and End Date for your survey.');
                $('#validate-filter-modal').modal('show');

                returnBoolean =  false;
            }
            // endDate lebih kecil dari today
            else if(jQuery('#completionDateTo').datepicker('getDate') < new Date()) {
                $('#labelHeaderForm', form).text('End Date is earlier than Today');
                $('#labelText', form).text('Please make sure that your completion End Date is not Earlier than today.');
                $('#validate-filter-modal').modal('show');

                returnBoolean =  false;
            }
            // endDate lebih kecil dari startdate
            else if( jQuery('#completionDateTo').datepicker('getDate') < jQuery('#completionDateFrom').datepicker('getDate')) {
                $('#labelHeaderForm', form).text('End Date is earlier than Start Date');
                $('#labelText', form).text('Please make sure that your completion End Date is not Earlier than your completion Start Date.');
                $('#validate-filter-modal').modal('show');
                returnBoolean =  false;
            }
            return returnBoolean;
        }

    </script>

</body>
</html>