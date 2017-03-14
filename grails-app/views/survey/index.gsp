<%--
  Created by IntelliJ IDEA.
  User: arnold
  Date: 3/24/13
  Time: 10:45 PM
--%>

<%@ page import="ticbox.Survey; ticbox.ProfileItem; ticbox.LookupMaster" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="surveyor"/>
    <title></title>

    <link rel="stylesheet" type="text/css" href="${resource(dir: 'frameworks/jqplot', file: 'jquery.jqplot.min.css')}" />

    <style type="text/css">

        /*.surveyItemContainer {*/
            /*margin-bottom: 10px;*/
            /*clear: right;*/
        /*}*/

        /*.surveyItemContainer .seqNumberContainer {*/
            /*width: 40px;*/
            /*vertical-align: top;*/
            /*text-align: right;*/
            /*padding-right: 5px;*/
        /*}*/

        /*.surveyItemContainer .questionNumber {*/
            /*font-size: 24px;*/
            /*font-weight: bold;*/
            /*color: #97b11a;*/
        /*}*/

        /*.chart-container {*/
            /*margin-left: 50px;*/
        /*}*/

        /*#displaySurveyResultModal {*/
            /*top: 5%;*/
        /*}*/

        /*#displaySurveyResultModal .modal-body {*/
            /*max-height: 450px;*/
        /*}*/

        /*#displaySurveyResultModal .modal-footer {*/
            /*padding: 5px 15px 5px;*/
        /*}*/

        #menuNavPanelContent {
            width: 100%;
        }

        .module-content .table tr.top-header th {
            background-color: rgba(134, 137, 122, 1.0); /* #86897a */
            font-weight: bold;
            height: 25px;
            color: #ffffff;
        }

        .module-content .table tr.sub-header th {
            font-weight: bold;

            background-color: lightgrey;
            background-image: linear-gradient(-45deg, rgba(255, 255, 255, 0.2) 25%, transparent 25%, transparent 50%, rgba(255, 255, 255, 0.2) 50%, rgba(255, 255, 255, 0.2) 75%, transparent 75%, transparent);

            background-size: 20px 20px;
            height: 15px;
            line-height: 15px;

        }

    </style>

    <style type="text/css">
        .paging-nav {
          text-align: right;
          padding-top: 2px;
        }

        .paging-nav a {
          margin: auto 1px;
          text-decoration: none;
          display: inline-block;
          padding: 1px 7px;
          background: #91b9e6;
          color: white;
          border-radius: 3px;
        }

        .paging-nav .selected-page {
          background: #187ed5;
          font-weight: bold;
        }

        .paging-nav,
        #tableData {
          width: 400px;
          margin: 0 auto;
          font-family: Arial, sans-serif;
        }
    </style>
</head>
<body>

<div id="menuNavPanelContent">
    %{--<div class="module">--}%
        %{--<div class="line side-panel">--}%
            %{--<div class="line header">--}%
                %{--Panel 1--}%
            %{--</div>--}%
            %{--<div class="line">--}%

            %{--</div>--}%

            %{--<hr>--}%
        %{--</div>--}%

        %{--<div class="line side-panel">--}%
            %{--<div class="line header">--}%
                %{--Panel 2--}%

            %{--</div>--}%
            %{--<div class="line">--}%

            %{--</div>--}%

            %{--<hr>--}%
        %{--</div>--}%
    %{--</div>--}%

    <div class="container-fluid" style="width: 100%">
        <!--div class="line" style="padding: 10px 1px">
            Start your success with a survey!
        </div-->
        <div class="panel-group">
            <div class="panel">
                <div class="panel-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <g:message code="app.startnow.label"/> >> <button style="border-radius: 8px;" id="createSurveyModalBtn" href="#createSurveyModal" role="button" data-toggle="modal" class="btn btn-green btn-sm" type="button"><g:message code="label.button.create" default="Create"/> <g:message code="app.survey.label"/></button>
                        </div>
                        <!--a id="addNewUser" href="#add-new-user-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> New User</a-->
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>


<div class="module">

    <div id="surveyHeader" class="module-header">
        <div class="title"><g:message code="ticbox.admin.survey.header"/></div>
    </div>

    <a href="#" id="showFilterBtn" onclick="showFilter()">Show filter</a>
    <script>
    function showFilter() {
        $('#filter').toggle('slow');
        $('#showFilterBtn').hide();
    }

    $(document).ready(function() {
        var filterFound = false;

        var nameFilter = '${nameFilter}';
        if (nameFilter != '') {
            $("#keywords").val(nameFilter);
            filterFound = true;
        }

        var respondentFilter = ${respondentFilter};
        if (respondentFilter) {
            for (var code in respondentFilter) {
                populateFilterComponent(code, respondentFilter[code]);
            };
            filterFound = true;
        }

        if (filterFound) {
            showFilter();
        }
    });
    </script>

    <div id="filter" style="display: none; width: 500px;">
        <h2>Filter</h2>
        <form class="form-horizontal">
            <div class="form-group">
                <label class="col-sm-3 control-label">Name</label>
                <div class="col-sm-9">
                    <input type="text" class="form-control" id="keywords" name="name" placeholder="Keywords">
                </div>
            </div>

<!--
            <div class="form-group" class="hidden">
                <label class="col-sm-3 control-label">Division</label>
                <div class="col-sm-9">
                    <label class="checkbox-inline">
                        <input type="checkbox" id="inlineCheckbox1" value="option1"> IT
                    </label>
                    <label class="checkbox-inline">
                        <input type="checkbox" id="inlineCheckbox2" value="option2"> Manager
                    </label>
                    <label class="checkbox-inline">
                        <input type="checkbox" id="inlineCheckbox3" value="option3"> HR
                    </label>
                </div>
            </div>
-->
            <div id="filterForm">
            </div>

            <div class="form-group">
                <label class="col-sm-3 control-label">Respondent filter</label>
                <div class="col-sm-7">
                    <select id="respondentFilterComponents" class="form-control">
                        <g:each in="${profileItems}" var="profileItem">
                            <option value="${profileItem.code}">${profileItem.label}</option>
                        </g:each>
                    </select>
                </div>
                <div class="col-sm-2">
                    <button id="addFilterBtn" class="btn btn-default">
                        <i class="glyphicon glyphicon-plus"></i>
                    </button>
                </div>
            </div>
        
            <script>
            // Copied from respondentFilter.gsp
            $('#addFilterBtn').click(function () {
                var filterComponentCode = jQuery('#respondentFilterComponents').val();
                populateFilterComponent(filterComponentCode);
                return false;
            });

            // Copied from respondentFilter.gsp
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
                                // Ultra simple
                                var filter_ = filter;
                                jQuery('input.check-item', template).each(function () {
                                    var chkBox = this;
                                    jQuery.each(filter_, function(idx, item) {
                                        if (jQuery(chkBox).val() == item) {
                                            jQuery(chkBox).parent().find('a').trigger('click');
                                        }
                                    });
                                })/*.prettyCheckable()*/;
                                break;

                        }
                    }
                }
            }
            
            </script>


            <div class="form-group">
                <div class="col-sm-offset-3 col-sm-9">
                    <input type="submit" class="btn btn-default" value="Search" />
                </div>
            </div>
        </form>
    </div>



<!-- Copied from respondentFilter -->
    <form id="filterTemplates" class="form-horizontal" style="display: none">
        <g:each in="${profileItems}" var="profileItem">
            <div class="profile-item-container form-group" code="${profileItem.code}" type="${profileItem.type}" label="${profileItem.label}" style="position: relative">
                <label class="col-sm-3 control-label" for="${profileItem.code}">${profileItem.label}</label>

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
                        </g:elseif>

                    </g:elseif>
                </div>
                <i class="remove-filter glyphicon glyphicon-remove clickable" style="position: absolute; top: 5px; right: 7px;"></i>
            </div>
        </g:each>
    </form>




    <div id="surveyList" class="module-content">
        <div style="width: 100%">
            <g:if test="${!submitted.isEmpty()}">
                <table class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr class="top-header">
                        <th colspan="4"><g:message code="app.submitted.status"/></th>
                    </tr>
                    <tr class="sub-header">
                        <th><g:message code="app.user.name.label"/></th>
                        <th><g:message code="app.price.label"/></th>
                        <th><g:message code="app.modified.label"/></th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:if test="${submitted.isEmpty()}">
                        <tr>
                            <td colspan="4" style="font-style: italic; font-size: 12px; color: #9f7032;"><g:message code="survey.nosurvey.label"/></td>
                        </tr>
                    </g:if>
                    <g:each in="${submitted}" var="survey">
                        <tr>
                            <td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </g:if>

            <table class="table table-striped table-bordered table-hover">
                <thead>
                <tr class="top-header">
                    <th colspan="6"><g:message code="app.draft.status"/></th>
                </tr>
                <tr class="sub-header">
                    <th><g:message code="app.user.name.label"/></th>
                    <th>Filter</th>
                    <th><g:message code="app.runningtime.label"/></th>
                    <th><g:message code="app.totalrespondent.label"/></th>
                    <th><g:message code="app.createdon.label"/></th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <g:if test="${drafts.isEmpty()}">
                    <tr>
                        <td colspan="7" style="font-style: italic; font-size: 12px; color: #9f7032;"><g:message code="survey.nosurvey.label"/></td>
                    </tr>
                </g:if>
                <g:each in="${drafts}" var="survey">
                    <tr>
                        <td><a href="${request.contextPath}/survey/editSurvey?surveyId=${survey.surveyId}">${survey.name}</a></td>
                        <td>${ticbox.Survey.getFilterLabels(survey).join(", ")}</td>
                        <td>${survey.completionDateFrom} - ${survey.completionDateTo}</td>
                        <td>${survey.ttlRespondent}</td>
                        <td>${survey.createdDate}</td>
                        <!-- Delete Draft -->
                        <td class="content-width">
                            <!-- a class="btn btn-xs btn-primary displayResultLink" surveyid="${survey.surveyId}" href="${request.contextPath}/survey/deleteSurvey?surveyId=${survey.surveyId}">Delete</a -->
                            <!--a class="btn btn-xs btn-primary displayResultLink" id="delDraft" href="#delete-drafts-modal" role="button"  data-toggle="modal">Delete</a-->
                            <button id="delDraft-${survey.surveyId}" href="#delete-drafts-modal-${survey.surveyId}"
                                    role="button" data-toggle="modal" class="btn btn-danger btn-xs"><g:message code="default.button.delete.label"/></button>
                        </td>



                        <div id="delete-drafts-modal-${survey.surveyId}" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="deleteDraftsLabel-${survey.surveyId}" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                                        <span id="deleteDraftsLabel-${survey.surveyId}" class="modal-title"><g:message code="default.button.delete.label"/></span>
                                    </div>
                                    <div class="modal-body">
                                        <g:form name="deleteDraftsForm" controller="admin" action="deleteDrafts" role="form">
                                            <input type="hidden" id="delDraftIds" name="delDraftIds" value=""/>
                                            <div class="well">
                                                <p><b><g:message code="app.admin.survey.delete.confirmation"/></b></p>
                                                <g:message code="app.admin.survey.delete.warning"/>
                                            </div>
                                        </g:form>
                                    </div>
                                    <div class="modal-footer">
                                        <!--button id="deleteDraft" class="btn btn-danger" data-loading-text="Processing..">Delete</button-->
                                        <a class="btn btn-danger" surveyid="${survey.surveyId}" href="${request.contextPath}/survey/deleteSurvey?surveyId=${survey.surveyId}"><g:message code="common.label.delete"/></a>
                                        <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/></button>
                                    </div>
                                </div>
                            </div>
                        </div>










                    </tr>
                </g:each>
                </tbody>
            </table>

            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr class="top-header">
                        <th colspan="8"><g:message code="app.inprogress.status"/></th>
                    </tr>
                    <tr class="sub-header">
                        <th><g:message code="app.user.name.label"/></th>
                        <th><g:message code="app.filter.label"/></th>
                        <th><g:message code="app.runningtime.label"/></th>
                        <th><g:message code="app.totalrespondent.label"/></th>
                        <th><g:message code="app.filledsurvey.label"/></th>
                        <th><g:message code="app.createdon.label"/></th>
                        <th>Published date</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <g:if test="${inProgress.isEmpty()}">
                        <tr>
                            <td colspan="8" style="font-style: italic; font-size: 12px; color: #9f7032;"><g:message code="survey.nosurvey.label"/></td>
                        </tr>
                    </g:if>
                    <g:each in="${inProgress}" var="survey">
                        <tr>
                            <td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td>
                            <td>${ticbox.Survey.getFilterLabels(survey).join(", ")}</td>
                            <td>${survey.completionDateFrom} - ${survey.completionDateTo}</td>
                            <td>${survey.ttlRespondent}</td>
                            <td>${survey.ttlRespondentSoFar}</td>
                            <td>${survey.createdDate}</td>
                            <td>${survey.publishedDate}</td>
                            <td class="content-width">
                                <a class="btn btn-xs btn-primary displayResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)"><g:message code="label.button.displayresult"/></a>
								<a class="btn btn-xs btn-primary downloadResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)"><g:message code="label.button.downloadresult"/></a>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

            <table class="table table-striped table-bordered table-hover">
                <thead>
                <tr class="top-header">
                    <th colspan="9"><g:message code="app.completed.status"/></th>
                </tr>
                <tr class="sub-header">
                    <th><g:message code="app.user.name.label"/></th>
                    <th>Filter</th>
                    <th><g:message code="app.type.label"/></th>
                    <th><g:message code="app.runningtime.label"/></th>
                    <th><g:message code="app.totalrespondent.label"/></th>
                    <th>Survey terisi</th>
                    <th><g:message code="app.createdon.label"/></th>
                    <th>Published date</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                    <g:if test="${completes.isEmpty()}">
                        <tr>
                            <td colspan="9" style="font-style: italic; font-size: 12px; color: #9f7032;"><g:message code="survey.nosurvey.label"/></td>
                        </tr>
                    </g:if>
                    <g:each in="${completes}" var="survey">
                        <tr>
                            <td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td>
                            <td>${ticbox.Survey.getFilterLabels(survey).join(", ")}</td>
                            <td>${survey.type}</td>
                            <td>${survey.completionDateFrom} - ${survey.completionDateTo}</td>
                            <td>${survey.ttlRespondent}</td>
                            <td>${survey.ttlRespondentSoFar}</td>
                            <td>${survey.createdDate}</td>
                            <td>${survey.publishedDate}</td>
                            <td class="content-width">
                                <a class="btn btn-xs btn-primary displayResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)"><g:message code="label.button.displayresult"/></a>
                            	<a class="btn btn-xs btn-primary downloadResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)"><g:message code="label.button.downloadresult"/></a>
							</td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

        </div>
    </div>
</div>

<div id="createSurveyModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="createSurveyModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="createSurveyModalLabel" class="modal-title">
                    <g:message code="app.createsurvey.label"/>
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <g:form name="createSurveyForm" controller="survey" action="createSurvey" class="form-horizontal" role="form" style="position: relative">
                    <div class="form-group">
                        <div class="col-sm-12">
                            <label for="surveyName"><g:message code="survey.uniquename.label"/></label>
                            <g:textField name="surveyName" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-sm-12">
                            <label><g:message code="survey.creationmethod.label"/></label>
                            <div class="radio">
                                <label>
                                    <g:radio id="surveyCreationRadio1" name="surveyCreationRadio" value="1" checked="true"/>
                                    <g:message code="admin.index.survey.createnew"/>
                                </label>
                            </div>
                            <div class="radio">
                                <label>
                                    <g:radio id="surveyCreationRadio2" name="surveyCreationRadio" value="2"/>
                                    <g:message code="admin.index.survey.editexisting"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="allSurveysListForm">
                        <div class="col-sm-offset-1 col-sm-11">
                            <div id="allSurveysListTr">
                                <label for="allSurveysListSelect"><g:message code="admin.index.survey.yoursurveylist" class="control-label"/></label>
                                <g:select id="allSurveysListSelect" name="allSurveysListSelect" from="${allSurveys}" optionKey="surveyId" optionValue="name" noSelection="${["":"${message(code: 'app.selectone.label')}"]}" class="form-control" style="min-width: 70%; width: auto;"/>
                            </div>
                        </div>
                    </div>
                         %{--
                        <table>
                             <tr>
                                <td><g:radio id="surveyCreationRadio1" name="surveyCreationRadio" value="1" checked="true"/></td>
                                <td colspan="2"><label class="radio" style="font-weight: normal; margin: 10px 0 15px 0"><g:message code="admin.index.survey.createnew"/></label></td>
                             </tr>
                             <tr>
                                <td><g:radio id="surveyCreationRadio2" name="surveyCreationRadio" value="2"/></td>
                                <td colspan="2"><label class="radio" style="font-weight: normal; margin: 10px 0 15px 0"><g:message code="admin.index.survey.editexisting"/></label></td>
                            </tr>
                            <tr id="allSurveysListTr">
                                <td></td>
                                <td><label class="radio" style="font-weight: normal; margin: 10px 0 15px 0"><g:message code="admin.index.survey.yoursurveylist"/>&nbsp;</label></td>
                                <td><g:select id="allSurveysListSelect" name="allSurveysListSelect" from="${allSurveys}" optionKey="surveyId" optionValue="name" noSelection="${["":"${message(code: 'app.selectone.label')}"]}" class="form-control"
                                          style="min-width: 20%; width: auto;"/></td>
                            </tr>
                        </table>
                        --}%
                </g:form>
            </div>
            <div class="modal-footer">
                <button id="createNewSurvey" class="btn btn-green" data-loading-text="Processing.."><g:message code="label.button.next"/></button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

<div id="displaySurveyResultModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="displaySurveyResultModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="displaySurveyResultModalLabel" class="modal-title">
                    Survey Result
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <div class="questionItemsContainer">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

<div class="templates" style="display: none">

    <div id="questionItemTemplate" class="surveyItemContainer">
        <div class="row">
            <div class="seqNumberContainer questionNumber col-xs-1"> </div>
            <div class="questionTextContainer col-xs-11" style="max-width: 90%">
                <!-- kucingkurus -->
                <span class="media-thumbnail">
                    <img class="pic question-pic" src="" style="width: auto; height: 120px; margin-left: 0;border-radius: 5px"/>
                </span>
                <span class="question-text"></span>
            </div>
        </div>
        <div class="chart-container row" style="padding-top: 10px;">
            <div class="col col-xs-11 col-xs-offset-1">
                <div class="chart" style="height:300px;width:500px;"></div><!-- width diremove untuk teks panjang -->
            </div>
        </div>

    </div>
</div>

<div id="surveyPreviewModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="surveyPreviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="surveyPreviewModalLabel" class="modal-title" >Survey Preview</span>
            </div>
            <div class="modal-body" style="overflow: auto; padding: 20px 50px 20px 20px">
                <div class="questionItemsContainer">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

<div class="templates" style="display: none">

    <div id="questionPreviewTemplate" class="surveyItemContainer">
        <div class="row">
            <div class="seqNumberContainer questionNumber col-xs-1"> </div>
            <div class="questionTextContainer col-xs-11">
                <!-- kucingkurus -->
                <span class="media-thumbnail">
                    <img class="pic question-pic" src="" style="width: auto; height: 120px; margin-left: 0;border-radius: 5px"/>
                </span>
                <span class="question-text"></span>
            </div>
        </div>
    </div>

    <!-- added template for youtube player template -->
    <div id="previewYoutubePlayerTemplate" class="row">
        <div class="seqNumberContainer questionNumber col-xs-1"> </div>
        <div class="col-xs-11" style="height: 100%; display: table; text-align: left;">
            <iframe type="text/html" width="320" height="240" frameborder="0" style="display:none;"></iframe>
        </div>
    </div>


    <div id="answerPreviewTemplate-singleText" class="answerTemplate row" type="${Survey.QUESTION_TYPE.FREE_TEXT}">
        <div class="col col-xs-11 col-xs-offset-1">
            <textarea class="form-control" rows="3" placeholder="" style="width: 100% !important;"></textarea>
        </div>
    </div>

    <div id="answerPreviewTemplate-multipleChoice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE}">
        <div class="choice-items col-xs-11 col-xs-offset-1">
            <div class="choice-item row">
                %{--<label class="checkbox">--}%
                %{--<div class="col col-xs-1" style="text-align: right">--}%
                <div class="col col-xs-1" style="width: 3.2%">
                    <input class="item-check" type="checkbox">
                    %{--</div>--}%
                    %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                </div>
                <div class="col col-xs-11" style="">
                    <div class="row">
                        <div class="col-xs-12">
                            <label class="item-label" style="font-weight: normal; margin-bottom: 0; margin-left: 0; width: 100%"></label>
                        </div>
                    </div>
                    <div class="row choice-item-pic">
                        <div class="col-xs-12">
                            <span class="media-thumbnail">
                                <img class="pic upload-pic" src="" style="width: auto; height: 90px; margin-left: 0; border-radius:5px"/>
                            </span>
                        </div>
                    </div>
                </div>
                %{--</label>--}%
            </div>
        </div>
    </div>

    %{--<div id="answerPreviewTemplate-singleChoice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE}">--}%
    %{--<div class="col col-xs-11 col-xs-offset-1">--}%
    %{--<select class="item-select" style="min-width: 200px">--}%
    %{--<option></option>--}%
    %{--</select>--}%
    %{--</div>--}%
    %{--</div>--}%

    <div id="answerPreviewTemplate-singleChoice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE}">
        <div class="choice-items col-xs-11 col-xs-offset-1">
            <div class="choice-item row">
                %{--<div class="col col-xs-1" style="text-align: right">--}%
                <div class="col col-xs-1" style="width: 3.2%">
                    <input class="item-check" type="radio">
                    %{--</div>--}%
                    %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                </div>
                <div class="col col-xs-11" style="">
                    <div class="row">
                        <div class="col-xs-12">
                            <label class="item-label" style="font-weight: normal; margin-bottom: 0; margin-left: 0; width: 100%"></label>
                        </div>
                    </div>
                    <div class="row choice-item-pic">
                        <div class="col-xs-12">
                            <span class="media-thumbnail">
                                <img class="pic upload-pic" src="" style="width: auto; height: 90px; margin-left: 0; border-radius:5px"/>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="answerPreviewTemplate-scale" class="answerTemplate row" type="${Survey.QUESTION_TYPE.SCALE_RATING}">
        <div class="col col-xs-11 col-xs-offset-1" style="overflow-x: auto;width: auto">
            <table class="table scale-table table-bordered table-responsive">
                <thead>
                <tr class="scale-head">
                    <th style="text-align: center;"></th>
                    %{--<th class="rating-label" style="text-align: center"></th>--}%
                </tr>
                </thead>
                <tbody>
                <tr class="scale-row">
                    <td class="row-label"> </td>
                    <td class="rating-weight" style="text-align: center">
                        <input type="radio" name="rd-1">
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="answerPreviewTemplate-starRating" class="answerTemplate row" type="${Survey.QUESTION_TYPE.STAR_RATING}">
    <div class="line stars col-xs-11 col-xs-offset-1">

    </div>
</div>

<script type="text/javascript" src="${resource(dir: 'js', file: 'chart-helper.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot', file: 'jquery.jqplot.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.pieRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.barRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.highlighter.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.categoryAxisRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.pointLabels.min.js')}"></script>

<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.cursor.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.dateAxisRenderer.min.js')}"></script>

<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"></script>
<script src="${resource(dir: 'js', file: 'paging.js')}"></script>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">

	jQuery.validator.addMethod("uniqueto", function(value, element, params) {
	
		var unique = true;
		var lowerCaseValue = value.toLocaleLowerCase();
		$(params + ' option').each(function(){
		    if (this.innerHTML.toLocaleLowerCase() === lowerCaseValue) {
		    	unique = false;
		        return false;
		    }
		});
	    return this.optional(element) || unique;
	    
	}, "${message(code: 'app.createsurvey.nonuniquename')}");

    $('#createSurveyModal').on('hide.bs.modal', function() {
    	var validator = $('#createSurveyForm').validate();
    	validator.resetForm();
        $('#surveyName').val('');
        $('#surveyCreationRadio1').prop("checked", true);
		$('#allSurveysListForm').hide();
    });

    $(document).ready(function() {

    	jQuery('#allSurveysListForm').hide();
    	
        // Validations
        $('#createSurveyForm').validate({
            rules: {
                surveyName: {
                    required: true,
                    uniqueto: "#allSurveysListSelect"
                },
                allSurveysListSelect: {
	                required: true
	            }
	        },
            messages: {
            	surveyName: {
                    required: "${message(code: 'label.field.required')}"
                },
                allSurveysListSelect: {
                    required: "${message(code: 'label.field.required')}"
                }
			}
        });

        $(document).on( "change", "input[name=surveyCreationRadio]", function() {
				if(this.value == '2') {
					jQuery('#allSurveysListForm').show();
				} else {
					jQuery('#allSurveysListForm').hide();
				}
		
             } );

        /* Add new survey submit button */
        $('#createNewSurvey').click(function() {
            var form = $('#createSurveyForm');

            if (form.valid()) {
                $('#surveyName').val($.trim($('#surveyName').val()));
                form.submit();
            } else {
                $(this).button('reset');
            }
        });
    });

    jQuery(function(){

        jQuery('.displayResultLink').click(function(){
            var that = jQuery(this);
            var surveyId = that.attr('surveyid');

            var txt = that.text();
            that.text('Loading Data..');

            jQuery.getJSON('${request.contextPath}/survey/getSurveyResult', {surveyId: surveyId}, function(result){
                if(!result.error){
                    jQuery('#displaySurveyResultModal').modal('show').find('.questionItemsContainer').empty();

                    setTimeout(function() {
                        loadResultGraph(result);

                        that.text(txt);
                    }, 500);
					jQuery('.displayResultLink').text('Display');
                }else {
                    alert(result.error);
                    that.text(txt);
                }
            });
            //that.text('Display Result');
        });
		jQuery('.downloadResultLink').click(function(e){
	        var that = jQuery(this);
            var surveyId = that.attr('surveyid');
            //that.text('Loading Data..');
           	e.preventDefault();  //stop the browser from following
			var url =  '${request.contextPath}/survey/downloadSurveyResult?surveyId='+surveyId;
			window.location.href =url;
            //that.text('Download Result');
        });

        jQuery('#surveyorProfileContent').addClass('in');
        jQuery('#surveyInfoAccordion').hide();

        jQuery('.displayQuestionLink').click(function(){
            var that = jQuery(this);
            var surveyId = that.attr('surveyid');

            // var txt = that.text();
            //that.text('Loading Data..');
            jQuery('#surveyPreviewModal .modal-body').empty();
            jQuery.getJSON('${request.contextPath}/survey/getQuestionItems', {surveyId: surveyId}, function(result){
                if(!result.error){
                    jQuery('#surveyPreviewModal').modal('show').find('.questionItemsContainer').empty();

                    setTimeout(function() {
                        loadQuestionGraph(result);
                    }, 500);
                }else {
                    alert(result.error);
                }
            });
        });

    });

    function loadQuestionGraph(questionItems){

        console.log('~ BEGIN constructPreview');
        jQuery.each(questionItems, function(idx, item){
            var questionStr = item.questionStr;
            var answerDetails = item.answerDetails;

            var questionTemplate = jQuery('#questionPreviewTemplate').clone().removeAttr('id');

            jQuery('.seqNumberContainer', questionTemplate).html(idx+1+'.');

            jQuery('.question-text', questionTemplate).html("<span style='font-size:24px;color:grey;'>"+questionStr.charAt(0)+"</span>" + questionStr.substring(1));

            //        kucingkurus
            if(typeof item.image != 'undefined' && item.image != '') {
                jQuery('img.question-pic', questionTemplate).attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId=' + item.image);
            } else {
                questionTemplate.find('.question-pic').css({ display: "none"});
            }

            var answerTemplate = null;

            switch(answerDetails.type){

                case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :

                    var choiceItems = answerDetails.choiceItems;
                    var choiceType = answerDetails.choiceType;

                    answerTemplate = jQuery('#answerPreviewTemplate-singleChoice').clone().removeAttr('id');

//                                jQuery.each(choiceItems, function(idx, choiceItem){
                    jQuery.each(choiceItems, function(j, choiceItem){
//                                    jQuery('.item-select', answerTemplate).append(jQuery('<option></option>').append(choiceItem).val(choiceItem));
                        var choiceItemContainer = jQuery('.choice-item:first', answerTemplate).clone();
                        jQuery('input.item-check', choiceItemContainer).attr('name', idx);
                        jQuery('input.item-check', choiceItemContainer).val(choiceItem);
                        jQuery('.item-label', choiceItemContainer).html(choiceItem.label);
//                                    answerTemplate.append(choiceItemContainer);
                        if (typeof choiceItem.image != 'undefined' && choiceItem.image != '') {
                            //choiceItemCont.find('img').attr('src', 'data:image;base64,' + choiceItem.image);
                            jQuery('img.upload-pic', choiceItemContainer).attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId=' + choiceItem.image);
                        }
                        else {
                            choiceItemContainer.find('.choice-item-pic').css({ display: "none"});
                        }
                        jQuery('.choice-items', answerTemplate).append(choiceItemContainer);  //<-- geuis edit
                    });
                    jQuery('.choice-item:first', answerTemplate).remove();

                    break;

                case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :

                    var choiceItems = answerDetails.choiceItems;
                    var choiceType = answerDetails.choiceType;

                    answerTemplate = jQuery('#answerPreviewTemplate-multipleChoice').clone().removeAttr('id');

//                                jQuery.each(choiceItems, function(idx, choiceItem){
                    jQuery.each(choiceItems, function(j, choiceItem){
                        var choiceItemContainer = jQuery('.choice-item:first', answerTemplate).clone();
                        jQuery('input.item-check', choiceItemContainer).val(choiceItem);
                        if (('' + choiceItem.label) === 'undefined') {
                          jQuery('.item-label', choiceItemContainer).html(choiceItem); // back compat
                        } else {
                          jQuery('.item-label', choiceItemContainer).html(choiceItem.label);
                        }

//                                    answerTemplate.append(choiceItemContainer);
                        if (typeof choiceItem.image != 'undefined' && choiceItem.image != '') {
                            //choiceItemCont.find('img').attr('src', 'data:image;base64,' + choiceItem.image);
                            jQuery('img.upload-pic', choiceItemContainer).attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId=' + choiceItem.image);
                        }
                        else {
                            choiceItemContainer.find('.choice-item-pic').css({ display: "none"});
                        }
                        jQuery('.choice-items', answerTemplate).append(choiceItemContainer);  //<-- geuis edit
                    });
                    jQuery('.choice-item:first', answerTemplate).remove();

                    break;

                case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                    answerTemplate = jQuery('#answerPreviewTemplate-singleText').clone().removeAttr('id');
                    jQuery('textarea', answerTemplate).attr('placeholder', answerDetails.questionPlaceholder);

                    break;

                case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                    answerTemplate = jQuery('#answerPreviewTemplate-scale').clone().removeAttr('id');

                    var ratingLabels = answerDetails.ratingLabels;
                    var rowLabels = answerDetails.rowLabels;

                    jQuery.each(ratingLabels, function(idx, ratingLabel){
                        jQuery('.scale-head', answerTemplate).append(jQuery('<th class="rating-label" style="text-align: center"></th>').html(ratingLabel));
                    });

                    jQuery.each(rowLabels, function(idx, rowLabel){
                        var scaleRow = jQuery('table.scale-table > tbody > tr.scale-row:first', answerTemplate).clone();
                        jQuery('.row-label', scaleRow).html(rowLabel);

                        jQuery.each(ratingLabels, function(idx, ratingLabel){
                            var ratingWeightCont = jQuery('td.rating-weight:first', scaleRow).clone();
                            jQuery('input', ratingWeightCont).attr('name', rowLabel);
                            scaleRow.append(ratingWeightCont);
                        });
                        jQuery('td.rating-weight:first', scaleRow).remove();

                        jQuery('table.scale-table > tbody', answerTemplate).append(scaleRow);
                    });
                    jQuery('table.scale-table > tbody > tr.scale-row:first', answerTemplate).remove();

                    break;

                case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                    answerTemplate = jQuery('#answerPreviewTemplate-starRating').clone().removeAttr('id');
                    var stars = jQuery('.stars', answerTemplate).empty();
                    for(var i = 0; i < parseInt(answerDetails.nofStars); i++){
                        jQuery('.stars', answerTemplate).append(jQuery('<div class="col star clickable" seq="'+i+'"></div>').click(function(){
                            var seq = parseInt(jQuery(this).attr('seq'));
                            jQuery('.star', stars).each(function(idx){
                                if(idx <= seq){
                                    jQuery(this).removeClass('basic');
                                    jQuery(this).addClass('active');
                                }else{
                                    jQuery(this).removeClass('active');
                                    jQuery(this).addClass('basic');
                                }
                            });

                        }));
                    }

                    break;

            }

            %{-- added youtube preview --}%
            constructYoutubePlayer(item, questionTemplate);

            if (answerTemplate) {
                questionTemplate.append(answerTemplate);
            }

            jQuery('#surveyPreviewModal').find('.modal-body').append(questionTemplate);

        });

    }

    /*
    * this function is use to construct youtube player review and put in the question template
    * */
    function constructYoutubePlayer(item, questionTemplate){
        var previewYoutubePlayerTemplate = null;
        if(typeof item.youtubeID != 'undefined' && item.youtubeID != '' ){
            previewYoutubePlayerTemplate = jQuery('#previewYoutubePlayerTemplate').clone().removeAttr('id');
            previewYoutubePlayerTemplate.find('iframe').removeAttr('id')
                .attr('src', 'http://www.youtube.com/embed/' + item.youtubeID + '?enablejsapi=1&origin=http://ticbox.co.id').css({display:"block"});
            var seqNumberSwitchPlace = questionTemplate.find('.seqNumberContainer').html();
            previewYoutubePlayerTemplate.find('.seqNumberContainer').html(seqNumberSwitchPlace);
            questionTemplate.find('.seqNumberContainer').html('&nbsp;');
            questionTemplate.prepend(previewYoutubePlayerTemplate);
        }else{
            //need additional testing to put some code here
            //jQuery('#previewYoutubePlayer').attr('src', '').css({display: "none"});
        }
    }

    function constructQuestionItemCont(questionStr, image, seq){

        var cont = jQuery('#questionItemTemplate').clone().attr('id', 'qi_'+seq);

        jQuery('.questionNumber', cont).html(seq + '.');
//        jQuery('.questionTextContainer > span.question-text', cont).html(questionStr);
        jQuery('.questionTextContainer > span.question-text', cont).html("<span style='font-size:24px;color:grey;'>"+questionStr.charAt(0)+"</span>" + questionStr.substring(1));

        jQuery('.chart-container .col .chart', cont).attr('id', 'chart_'+seq);

        //        kucingkurus
        if(typeof image != 'undefined' && image != '') {
            jQuery('img.question-pic', cont).attr('src', '${request.contextPath}/survey/viewResources?resType=IMAGE&resourceId=' + image);
        } else {
        cont.find('.question-pic').css({ display: "none"});
        }
        return cont;
    }

    function loadResultGraph(result){

        var questionItemsContainer = jQuery('#displaySurveyResultModal').find('.questionItemsContainer');
        var renderer = new SurveyChartRenderer();

        if (result) {

            jQuery.each(result, function(key, item){
                var questionItem = item.questionItem;
                var summary = item.summary;

                var answerDetails = questionItem.answerDetails;
                var container = constructQuestionItemCont(questionItem.questionStr, questionItem.image, key);

                //added display youtube player if youtubeID is exist
                constructYoutubePlayer(questionItem, container);

                questionItemsContainer.append(container);

                var target = jQuery('.chart-container .col .chart:first', container);

                switch(answerDetails.type){

                    case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
                        var labels = [];
                        var counts = [];

                        if (summary){
                            jQuery.each(answerDetails.choiceItems, function (i, choiceItem) {
                                var label = choiceItem.label;
                                labels.push(label);
                                //labels.push(label.substring(0, 40));
                                counts.push(label in summary ? summary[label] : 0);
                            });

                            renderer.forChoice(labels, counts, target, 'Answer Type - Single Choice');
                        }
                        break;
                    case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :
                        var labels = [];
                        var counts = [];

                        if (summary){
                            jQuery.each(answerDetails.choiceItems, function (i, choiceItem) {
                                var label = choiceItem.label;
                                if (('' + label) === 'undefined') { // back compat
                                  label = choiceItem;
                                }
                                labels.push(label);
                                counts.push(label in summary ? summary[label] : 0);
                            });

                            renderer.forChoice(labels, counts, target, 'Answer Type - Multiple Choice');
                        }
                        break;

                    case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                        if (summary) {
                            var MAX_NUM_OF_ANSWERS = 10;
                            // var answers = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ultricies commodo enim, eu euismod tortor porta ac. Sed in leo vulputate, aliquam eros tincidunt, condimentum ante. Nullam sed justo sit amet dolor feugiat commodo sed sed orci. Nullam tincidunt quis nunc eu lobortis. Pellentesque dolor diam, hendrerit quis imperdiet vel, aliquam in nibh. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam nec suscipit massa. Phasellus lorem eros, tincidunt ac interdum et, efficitur sed neque. Aenean bibendum mi libero, vitae porta nunc placerat pretium. Integer fermentum, purus quis molestie elementum, orci est dictum diam, nec tristique odio tellus a turpis. Sed non nibh vestibulum, varius sem sed, tristique nisi. Aenean velit ligula, eleifend eget tincidunt ac, sagittis et tellus. Integer ac purus in diam cursus placerat ac a tellus. Sed rutrum est et aliquet tincidunt. In id sapien condimentum, euismod elit vel, congue lectus. Nullam lacus augue, viverra quis ex in, finibus malesuada dolor'.split(".");
                            var answers = summary;

                            var tab = jQuery('<table class="table table-bordered table-striped"></table>');
                            var tbody = jQuery('<tbody sytle="height: 100px; overflow-y: auto; overflow-x: hidden;"></tbody>');
                            jQuery.each(answers, function (index, val) {
                                var row = jQuery('<tr><td>' + (index+1)+". " +  val + '</td></tr>');
                                tbody.append(row);
                            });
                            tab.append(tbody);
                            target.append(tab);

                            tab.paging({limit: MAX_NUM_OF_ANSWERS});
                        }
                        break;

                    case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                        if (summary) {
                            var itemValuesRows = [];

                            jQuery.each(answerDetails.rowLabels, function (i, rowLabel) {
                                var values = [];
                                jQuery.each(answerDetails.ratingLabels, function (j, colLabel) {
                                    values[j] = summary[rowLabel][colLabel] ? summary[rowLabel][colLabel] : 0;
                                });
                                itemValuesRows.push({'label': rowLabel, 'values': values});
                            });

                            renderer.forScale(answerDetails.ratingLabels, itemValuesRows, target, 'Answer Type - Scale');

                        }
                        break;

                    case '${Survey.QUESTION_TYPE.STAR_RATING}' :
                        var amounts = [];
                        if (summary) {
                            var i = 0;
                            for (i = 0; i < answerDetails.nofStars; i++) {
                                amounts[i] = 0;
                            }

                            jQuery.each(summary, function (star, count) {
                                amounts[star - 1] = count;
                            });

                            renderer.forStar(amounts, target, 'Answer Type - Star Rating');
                        }
                        break;

                }

            });

        }

    }

</script>

</body>
</html>
