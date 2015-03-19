<%--
  Created by IntelliJ IDEA.
  User: arnold
  Date: 3/24/13
  Time: 10:45 PM
--%>

<%@ page import="ticbox.Survey" contentType="text/html;charset=UTF-8" %>
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

    <div class="" style="width: 100%">
        <div class="line line-centered">
            <button style="border-radius: 8px; width: 100%" id="createSurveyModalBtn" href="#createSurveyModal" role="button" data-toggle="modal" class="btn btn-green btn-lg" type="button"><g:message code="label.button.create" default="Create"/> Survey</button>
            <!--a id="addNewUser" href="#add-new-user-modal" role="button" class="btn btn-primary" data-toggle="modal"><i class="icon-plus icon-white"></i> New User</a-->
        </div>
    </div>

</div>


<div class="module">

    <div id="surveyHeader" class="module-header">
        <div class="title">Your Survey List</div>
    </div>
    <div id="surveyList" class="module-content">
        <div style="width: 100%">
            <g:if test="${!submitted.isEmpty()}">
                <table class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr class="top-header">
                        <th colspan="4">SUBMITTED</th>
                    </tr>
                    <tr class="sub-header">
                        <th>Name</th>
                        <th>Total Charge</th>
                        <th>Modified</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:if test="${submitted.isEmpty()}">
                        <tr>
                            <td colspan="4" style="font-style: italic; font-size: 12px; color: #9f7032;">No survey yet..</td>
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
                    <th colspan="6">DRAFTS</th>
                </tr>
                <tr class="sub-header">
                    <th>Name</th>
                    <th>Type</th>
                    <th>Running Time</th>
                    <th>Total Respondent</th>
                    <th>Total Charge</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <g:if test="${drafts.isEmpty()}">
                    <tr>
                        <td colspan="4" style="font-style: italic; font-size: 12px; color: #9f7032;">No survey yet..</td>
                    </tr>
                </g:if>
                <g:each in="${drafts}" var="survey">
                    <tr>
                        <td><a href="${request.contextPath}/survey/editSurvey?surveyId=${survey.surveyId}">${survey.name}</a></td>
                        <td>${survey.type}</td>
                        <td>${survey.completionDateFrom} - ${survey.completionDateTo}</td>
                        <td>${survey.ttlRespondent}</td>
                        <td>Rp. ${survey.surveyPrice}</td>
                        <!-- Delete Draft -->
                        <td class="content-width">
                            <!-- a class="btn btn-xs btn-primary displayResultLink" surveyid="${survey.surveyId}" href="${request.contextPath}/survey/deleteSurvey?surveyId=${survey.surveyId}">Delete</a -->
                            <!--a class="btn btn-xs btn-primary displayResultLink" id="delDraft" href="#delete-drafts-modal" role="button"  data-toggle="modal">Delete</a-->
                            <button id="delDraft" href="#delete-drafts-modal"
                                    role="button" data-toggle="modal" class="btn btn-danger">Delete</button>
                        </td>



                        <div id="delete-drafts-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="deleteDraftsLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                                        <span id="deleteDraftsLabel" class="modal-title">Delete Drafts</span>
                                    </div>
                                    <div class="modal-body">
                                        <g:form name="deleteDraftsForm" controller="admin" action="deleteDrafts" role="form">
                                            <input type="hidden" id="delDraftIds" name="delDraftIds" value=""/>
                                            <div class="well">
                                                <p><b>Are you sure to delete this draft?</b></p>
                                                There is no rollback for deleted draft. Please make sure you know what you are doing.
                                            </div>
                                        </g:form>
                                    </div>
                                    <div class="modal-footer">
                                        <!--button id="deleteDraft" class="btn btn-danger" data-loading-text="Processing..">Delete</button-->
                                        <a class="btn btn-danger" surveyid="${survey.surveyId}" href="${request.contextPath}/survey/deleteSurvey?surveyId=${survey.surveyId}">Delete</a>
                                        <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true">Cancel</button>
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
                        <th colspan="6">IN PROGRESS</th>
                    </tr>
                    <tr class="sub-header">
                        <th>Name</th>
                        <th>Type</th>
                        <th>Running Time</th>
                        <th>Total Respondent</th>
                        <th>Total Charge</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <g:if test="${inProgress.isEmpty()}">
                        <tr>
                            <td colspan="4" style="font-style: italic; font-size: 12px; color: #9f7032;">No survey yet..</td>
                        </tr>
                    </g:if>
                    <g:each in="${inProgress}" var="survey">
                        <tr>
                            <td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td>
                            <td>${survey.type}</td>
                            <td>${survey.completionDateFrom} - ${survey.completionDateTo}</td>
                            <td>${survey.ttlRespondent}</td>
                            <td>Rp. ${survey.surveyPrice}</td>
                            <td class="content-width">
                                <a class="btn btn-xs btn-primary displayResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)">Display Result</a>
                            </td>
                        </tr>
                    </g:each>
                </tbody>
            </table>

            <table class="table table-striped table-bordered table-hover">
                <thead>
                <tr class="top-header">
                    <th colspan="6">COMPLETED</th>
                </tr>
                <tr class="sub-header">
                    <th>Name</th>
                    <th>Type</th>
                    <th>Running Time</th>
                    <th>Total Respondent</th>
                    <th>Total Charge</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                    <g:if test="${completes.isEmpty()}">
                        <tr>
                            <td colspan="4" style="font-style: italic; font-size: 12px; color: #9f7032;">No survey yet..</td>
                        </tr>
                    </g:if>
                    <g:each in="${completes}" var="survey">
                        <tr>
                            <td><a class="displayQuestionLink" href="javascript:void(0)" surveyid="${survey.surveyId}">${survey.name}</a></td>
                            <td>${survey.type}</td>
                            <td>${survey.completionDateFrom} - ${survey.completionDateTo}</td>
                            <td>${survey.ttlRespondent}</td>
                            <td>Rp. ${survey.surveyPrice}</td>
                            <td class="content-width">
                                <a class="btn btn-xs btn-primary displayResultLink" surveyid="${survey.surveyId}" href="javascript:void(0)">Display Result</a>
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
                    Create Survey
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
                <g:form name="createSurveyForm" controller="survey" action="createSurvey" class="form-horizontal" role="form">
                    <label for="surveyName">Please name your survey</label>
                    <!--input type="text" class="form-control" id="surveyName" name="surveyName" param-of="createSurveyBtn"-->
                    <g:textField name="surveyName" class="form-control"/>
                </g:form>
            </div>
            <div class="modal-footer">
                <!--button href="${request.contextPath}/survey/createSurvey" id="createSurveyBtn" class="btn btn-green submit-redirect">
                    <!--g:message code="label.button.create" default="Create"/-->
                <!--/button-->
                <button id="createNewSurvey" class="btn btn-green" data-loading-text="Processing..">Create New Survey</button>
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
                <span class="question-text"></span>
            </div>
        </div>
        <div class="chart-container row" style="padding-top: 10px;">
            <div class="col col-xs-11 col-xs-offset-1">
                <div class="chart" style="height:300px;width:500px;"></div>
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
                <span class="question-text"></span>
            </div>
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
                <div class="col col-xs-12">
                    <input class="item-check" type="checkbox">
                    %{--</div>--}%
                    %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                    <span class="item-label" style="font-weight: normal; margin-bottom: 0"></span>
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
                <div class="col col-xs-12">
                    <input class="item-check" type="radio">
                    %{--</div>--}%
                    %{--<div class="col col-xs-11" style="padding-left: 0">--}%
                    <span class="item-label" style="font-weight: normal; margin-bottom: 0"></span>
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

<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot', file: 'jquery.jqplot.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.pieRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.barRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.highlighter.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.categoryAxisRenderer.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.pointLabels.min.js')}"></script>

<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.cursor.min.js')}"></script>
<script type="text/javascript" src="${resource(dir: 'frameworks/jqplot/plugins', file: 'jqplot.dateAxisRenderer.min.js')}"></script>

<g:javascript src="jquery.validate.min.js"/>
<g:javascript src="additional-methods.min.js"/>
<script type="text/javascript">

    $(document).ready(function() {

        // Validations
        $('#createSurveyForm').validate({
            rules: {
                surveyName: {
                    required: true
                }
            }
        });

        /* Add new survey submit button */
        $('#createNewSurvey').click(function() {
            $(this).button('loading');
            var form = $('#createSurveyForm');
            if (form.valid()) {
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
                }else {
                    alert(result.error);
                    that.text(txt);
                }
            });
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
                        jQuery('.item-label', choiceItemContainer).html(choiceItem);
//                                    answerTemplate.append(choiceItemContainer);
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
                        jQuery('.item-label', choiceItemContainer).html(choiceItem);
//                                    answerTemplate.append(choiceItemContainer);
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

            if (answerTemplate) {
                questionTemplate.append(answerTemplate);
            }

            jQuery('#surveyPreviewModal').find('.modal-body').append(questionTemplate);

        });

    }

    function constructQuestionItemCont(questionStr, seq){

        var cont = jQuery('#questionItemTemplate').clone().attr('id', 'qi_'+seq);

        jQuery('.questionNumber', cont).html(seq + '.');
//        jQuery('.questionTextContainer > span.question-text', cont).html(questionStr);
        jQuery('.questionTextContainer > span.question-text', cont).html("<span style='font-size:24px;color:grey;'>"+questionStr.charAt(0)+"</span>" + questionStr.substring(1));

        jQuery('.chart-container .col .chart', cont).attr('id', 'chart_'+seq);

        return cont;
    }

    function loadResultGraph(result){

        var questionItemsContainer = jQuery('#displaySurveyResultModal').find('.questionItemsContainer');

        if (result) {

            jQuery.each(result, function(key, item){

                var questionItem = item.questionItem;
                var summary = item.summary;

                var answerDetails = questionItem.answerDetails;
                var container = constructQuestionItemCont(questionItem.questionStr, key);

                questionItemsContainer.append(container);

                var target = jQuery('.chart-container .col .chart:first', container);

                switch(answerDetails.type){

                    case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
                    case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :

                        var data = [];

                        if(summary){
                            jQuery.each(summary, function (label, count) {
                                data.push([label, count]);
                            });

                            constructPieChart(target, data, 'Answer Type - Choice');
                        }
                        break;

                    case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                        if(summary) {
                            var line1 = [
                                ['23-May-08', 578.55],
                                ['20-Jun-08', 566.5],
                                ['25-Jul-08', 480.88],
                                ['22-Aug-08', 509.84],
                                ['26-Sep-08', 454.13],
                                ['24-Oct-08', 379.75],
                                ['21-Nov-08', 303],
                                ['26-Dec-08', 308.56],
                                ['23-Jan-09', 299.14],
                                ['20-Feb-09', 346.51],
                                ['20-Mar-09', 325.99],
                                ['24-Apr-09', 386.15]
                            ];
                            var tab = jQuery("<table></table>");
                            jQuery.each(summary, function (index, val) {
                                var row = jQuery('<tr><td>' + (index+1)+". " +  val + '</td></tr>');
                                tab.append(row);
                            });
                            target.append(tab);

//                            constructLineChart(target, line1, 'Answer Type - Free Text');
                        }
                        break;

                    case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                        if(summary) {
                            var ticks =[];
                            var series =[];
                            var dataAll=[];
                            var len= summary.length;
                            var last;

                            jQuery.each(summary, function (rowLabel, rowSummary) {

                                var data = [];
                                last=rowSummary;
                                ticks.push(rowLabel);
                                jQuery.first
                                jQuery.each(rowSummary, function (colLabel, count) {
                                    data.push(count);
                                });
                                dataAll.push(data);

                            });
                            jQuery.each(last, function (colLabel, count) {
                                series.push({label:colLabel});
                            });

//                            var targetCopy = target.clone();

                            jQuery('.chart-container .col', container).append(target);


                            constructMultipleChart(target, dataAll, 'Scale Rating',ticks,series);

//                            target.remove();
                        }
                        break;

                    case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                        var data = [];
                        if(summary) {
                            jQuery.each(summary, function (label, count) {
                                data.push([label, count]);
                            });

                            constructPieChart(target, data, 'Answer Type - Star Rating');
                        }
                        break;

                }

            });

        }

    }

    function constructPieChart(target, data, title){

        return jQuery.jqplot (target, [data],
                {
                    seriesDefaults: {
                        // Make this a pie chart.
                        renderer: jQuery.jqplot.PieRenderer,
                        rendererOptions: {
                            // Put data labels on the pie slices.
                            // By default, labels show the percentage of the slice.
                            showDataLabels: true
                        }
                    },
                    legend: { show:true, location: 'e' },
                    title: {
                        text: title?title:'',
                        show: title != null
                    }
                }
        );

    }

    function constructMultipleChart(target, data, title,ticks,series){

        return jQuery.jqplot (target, data,
                {
                    stackSeries: true,
//                    captureRightClick: true,
                    seriesDefaults:{
                        renderer:$.jqplot.BarRenderer,
                        rendererOptions: {
                            // Put a 30 pixel margin between bars.
//                            barMargin: 30,
                            // Highlight bars when mouse button pressed.
                            // Disables default highlighting on mouse over.
//                            highlightMouseDown: true
                            barDirection: 'horizontal'
                        },
                        pointLabels: {show: true}
                    },series:series,

                    axes: {
                        yaxis: {
                            renderer: $.jqplot.CategoryAxisRenderer,
                            ticks:ticks
                        }
                    },
                    legend: { show:true, location: 'e' },
                    title: {
                        text: title?title:'',
                        show: title != null
                    }

                }
        );

    }

    function constructLineChart(target, data, title){

        return jQuery.jqplot(target, [data], {
            title:'Data Point Highlighting',
            axes:{
                xaxis:{
                    renderer:jQuery.jqplot.DateAxisRenderer,
                    tickOptions:{
                        formatString:'%b&nbsp;%#d'
                    }
                },
                yaxis:{
                    tickOptions:{
                        formatString:'$%.2f'
                    }
                }
            },
            highlighter: {
                show: true,
                sizeAdjust: 7.5
            },
            cursor: {
                show: false
            },
            title: {
                text: title?title:'',
                show: title != null
            }
        });
    }

</script>

</body>
</html>