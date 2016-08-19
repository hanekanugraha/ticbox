<%@ page import="ticbox.Survey" contentType="text/html;charset=UTF-8" %>
<html>
<head>
<meta name="layout" content="respondent"/>
<title></title>

<style type="text/css">

    /*.surveyItemsContainer input, .surveyItemsContainer textarea, .surveyItemsContainer select {*/
        /*margin: 0;*/
    /*}*/

    /*.surveyItemsContainer input[type=text], .surveyItemsContainer textarea {*/
        /*width: 500px;*/
    /*}*/

    /*.surveyItemContainer {*/
        /*margin-bottom: 10px;*/
        /*clear: right;*/
    /*}*/

    /*.surveyItemContainer .seqNumberContainer {*/
        /*width: 40px;*/
        /*vertical-align: top;*/
        /*text-align: right;*/
        /*padding-right: 5px;*/
        /*line-height: 30px;*/
    /*}*/

    /*.questionTextContainer {*/
        /*line-height: 30px;*/
        /*vertical-align: bottom;*/
    /*}*/

    /*.questionNumber {*/
        /*font-size: 24px;*/
        /*font-weight: bold;*/
        /*color: #97b11a;*/
    /*}*/

    /*.surveyItemContainer table {*/
        /*margin-bottom: 0;*/
    /*}*/

    /*.surveyItemContainer .table th, .surveyItemContainer .table td {*/
        /*padding: 5px 1px;*/
    /*}*/

    /*.answerTemplate {*/
        /*margin: 0 0 0 45px;*/
    /*}*/

    /*.star {*/
        /*background:transparent url('../images/ticbox/question_BasicState.png');*/
        /*background-position: 52px -10px;*/
        /*width: 52px; height: 52px;*/
    /*}*/

    /*.stars:hover .star, .star.active{*/
        /*background:transparent url('../images/ticbox/question_ActiveState.png');*/
        /*background-position: 52px -10px;*/
    /*}*/

    /*.star:hover ~ .star, .star.basic{*/
        /*background:transparent url('../images/ticbox/question_BasicState.png');*/
        /*background-position: 52px -10px !important;*/
    /*}*/


        img.upload-pic {
            width: auto;
            max-height: 150px;
        }

</style>

<script type="text/javascript">

    var ttlQuestions = 0;
    var questionSeq = 1;

    jQuery(function () {

        jQuery('.enableTooltip').tooltip({
            selector: "button[data-toggle=tooltip]"
        });

        jQuery('#submitAnswers').click(function() {
            if(validateCurrentQuestion()) {
                $('#submit-answers-modal').modal('show');
            }else {
                $('#validate-question-modal').modal('show');
            }
        });

        jQuery('#saveResponse').click(function () {
            var questionItems = buildSurveyResponseMap();
            saveResponse(questionItems, this);
        });

        jQuery('#nextQuestion').click(function () {

            if(validateCurrentQuestion()) {

                var lastQuestion= jQuery('#question'+questionSeq).attr('hidden',true);
                var nextSeq = jQuery('input.item-check:checked',lastQuestion).attr('nextQuestion');
                if(nextSeq!=null||nextSeq==undefined)
                    questionSeq++;
                else
                    questionSeq=nextSeq;
                jQuery('#question'+questionSeq).attr('hidden',false);
                jQuery('#lastQuestion').show();
                if(questionSeq>=ttlQuestions) {
                    jQuery('#nextQuestion').hide();
                    jQuery('#submitAnswers').show();
                }
            }else {
                $('#validate-question-modal').modal('show');
            }

        });

        jQuery('#lastQuestion').click(function() {
            var currQuestion = jQuery('#question' + questionSeq).attr('hidden', true);
            var lastSeq = jQuery('input.item-check:checked', currQuestion).attr('lastQuestion');
            if(lastSeq!=null||lastSeq==undefined)
                questionSeq--;

            jQuery('#question' + questionSeq).attr('hidden', false);
            jQuery('#nextQuestion').show();
            jQuery('#submitAnswers').hide();
            if(questionSeq==1)
                jQuery('#lastQuestion').hide();
        });


        jQuery('#surveyName').text('${survey.name}');
        jQuery('#surveyTitle').text('${survey.title}');

        jQuery.getJSON('${request.contextPath}/respondent/getSurvey', {surveyId: '${survey.surveyId}'}, function (questionItems) {

            loadSurvey(questionItems);
            if(questionItems.length<2) {
                jQuery('#nextQuestion').hide();
            } else{
                jQuery('#submitAnswers').hide();
            }

            jQuery('#lastQuestion').hide();

        });

    });

    function validateCurrentQuestion() {
        var currQuestion = jQuery('#question'+questionSeq);
        var type = jQuery('.answerTemplate', currQuestion).attr('type');
        var answerDetails = {};
        var returnBoolean = true;

        switch (type) {
            case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
            case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :
                answerDetails['value'] = [];
                jQuery('.item-check:checked', currQuestion).each(function () {
                    answerDetails['value'].push(jQuery(this).val());
                });

                if(answerDetails['value']==null||answerDetails['value']==undefined||answerDetails['value']=='') {

                    return false;
                }
                return true;
                break;
            case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                answerDetails['value'] = jQuery('textarea', currQuestion).val();
                if(answerDetails['value']==null||answerDetails['value']==undefined||answerDetails['value']=='') {
                    return false;
                }
                return true;
                break;

            case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                answerDetails['value'] = {};
                var isValid = true;
                jQuery('.scale-row', currQuestion).each(function () {
                    var label = jQuery(this).find('.row-label').text();
                    var value = jQuery(this).find('input:checked').val();

                    if(!value){
                        isValid = false;
                        return false;
                    }
                });

                return isValid;
                break;

            case '${Survey.QUESTION_TYPE.STAR_RATING}' :
                answerDetails['value'] = jQuery('.stars .star.active', currQuestion).length;
                if(answerDetails['value']==null||answerDetails['value']==undefined||answerDetails['value']=='') {
                    return false
                }
                return true;
                break;
        }
    }

    function constructQuestionItem(type, subtype) {
        var answerComp = null;

        var changeTypeIconClass = '';

        switch (type) {

            case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
            case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :
                if (type == '${Survey.QUESTION_TYPE.CHOICE_SINGLE}') {
                    answerComp = jQuery('#answerTemplate-choice-single').clone().removeAttr('id');
                    jQuery('.item-check', answerComp).attr('type', 'radio');
                } else if (type == '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}') {
                    answerComp = jQuery('#answerTemplate-choice-multiple').clone().removeAttr('id');
                    jQuery('.item-check', answerComp).attr('type', 'checkbox');
                }

                break;

            case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                answerComp = jQuery('#answerTemplate-singleText').clone().removeAttr('id');
                changeTypeIconClass = 'free-text-icon';

                break;

            case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                answerComp = jQuery('#answerTemplate-scale').clone().removeAttr('id');
                changeTypeIconClass = 'scale-rating-icon';

                break;

            case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                answerComp = jQuery('#answerTemplate-starRating').clone().removeAttr('id');
                changeTypeIconClass = 'star-rating-icon';

                break;

        }

        var questionComp = jQuery('#questionTemplate').clone().removeAttr('id').append(answerComp).appendTo('.surveyItemsContainer');

        jQuery('.change-question-type-btn', questionComp).addClass(changeTypeIconClass);

        jQuery('.surveyItemsContainer > .surveyItemContainer').each(function (idx) {
            jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
        });

        jQuery('.surveyItemActions .remove', questionComp).click(function () {
            jQuery(this).parents('.surveyItemContainer').remove();
            jQuery('.surveyItemsContainer > .surveyItemContainer').each(function (idx) {
                jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
            });
        });

        return questionComp;
    }

    function buildSurveyResponseMap() {
        var responseItem = [];
        var seq = 0;

        jQuery('.surveyItemsContainer > .surveyItemContainer').each(function () {

            var container = jQuery(this);
            var type = jQuery('.answerTemplate', container).attr('type');

            var questionStr = jQuery('.questionTextContainer > div', container).text();
            var answerDetails = {};
            answerDetails['type'] = type;

            switch (type) {

                case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
                case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :
                    answerDetails['value'] = [];
                    jQuery('.item-check:checked', container).each(function () {
                        answerDetails['value'].push(jQuery(this).val());
                    });

                    break;

                case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                    answerDetails['value'] = jQuery('textarea', container).val();
                    break;

                case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                    answerDetails['value'] = {};
                    jQuery('.scale-row', container).each(function () {
                        var label = jQuery(this).find('.row-label').text();
                        var value = jQuery(this).find('input:checked').val();
                        answerDetails['value'][label] = (value) ? value : '';
                    });
                    break;

                case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                    answerDetails['value'] = jQuery('.stars .star.active', container).length;

                    break;

            }

            responseItem.push({
                seq : ++seq,
                answerDetails: answerDetails
            });

        });

        return responseItem
    }

    function saveResponse(questionItems, btn) {
        jQuery(btn).attr('disabled', 'disabled');
        jQuery.post('${request.contextPath}/respondent/saveResponse', {surveyResponse: JSON.stringify(questionItems), surveyId: '${survey.surveyId}', respondentId: ${respondent.id}}, function (data) {

            if ('SUCCESS' == data) {
//                alert('Submission success..');
                window.location.replace('${request.contextPath}/respondent/');
            } else {
//                alert('Submission failure');
                jQuery(btn).removeAttr('disabled');
            }

        });
    }

    function loadSurvey(questionItems) {

        if (questionItems) {

            jQuery.each(questionItems, function (i, item) {

                var answerDetails = item.answerDetails;
                var container = null;

                switch (answerDetails.type) {

                    case '${Survey.QUESTION_TYPE.CHOICE_SINGLE}' :
                    case '${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}' :

                        var choiceItems = answerDetails.choiceItems;
                        var choiceType = answerDetails.choiceType;

                        container = constructQuestionItem(answerDetails.type, choiceType);

                        jQuery.each(choiceItems, function (j, choiceItem) {
                            var choiceItemCont = jQuery('.choice-items > .choice-item:first', container).clone();
                            choiceItemCont.find('.item-check').attr('name', i);
                            if(choiceItem.label != 'undefined') {
                                choiceItemCont.find('.item-check').val(choiceItem.label);
                            }
                            else {
                                // Back compat
                                choiceItemCont.find('.item-check').val(choiceItem);
                            }

//                            if (choiceItem.image != null && choiceItem.image != '') {
                            if (typeof choiceItem.image != 'undefined' && choiceItem.image != '') {
                                //choiceItemCont.find('img').attr('src', 'data:image;base64,' + choiceItem.image);
                                jQuery('img.upload-pic', choiceItemCont).attr('src', '${request.contextPath}/respondent/viewResources?resType=IMAGE&resourceId=' + choiceItem.image);
                            }
                            else {
                                choiceItemCont.find('.choice-item-pic').css({ display: "none"});
                            }

                            choiceItemCont.find('.item-check').attr('nextQuestion',choiceItem.nextQuestion);
                            jQuery('.choice-items', container).append(choiceItemCont);
                            if(choiceItem.label != 'undefined') {
                                jQuery('.item-label', choiceItemCont).text(choiceItem.label);
                            }
                            else{
                                jQuery('.item-label', choiceItemCont).text(choiceItem);
                            }
                            choiceItemCont.attr('nextquestion',choiceItem.nextQuestion);
                        });
                        jQuery('.choice-items > .choice-item:first', container).remove();

                        jQuery('select.choice-type', container).val(choiceType);

                        break;

                    case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                        var questionPlaceHolder = answerDetails.questionPlaceholder;

                        container = constructQuestionItem(answerDetails.type);

                        jQuery('textarea.place-holder-text', container).attr('placeholder', questionPlaceHolder);

                        break;

                    case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                        var ratingLabels = answerDetails.ratingLabels;
                        var rowLabels = answerDetails.rowLabels;

                        container = constructQuestionItem(answerDetails.type);

                        var first = jQuery('table.scale-table > thead th.rating-label:first', container);
                        var thead = jQuery('table.scale-table > thead tr', container);
                        jQuery.each(ratingLabels, function (idx, ratingLabel) {
                            var ratingLabelCont = first.clone();
                            thead.append(ratingLabelCont);
                            jQuery('div', ratingLabelCont).text(ratingLabel);
                        });
                        jQuery('table.scale-table > thead th.rating-label:first', container).remove();

                        var masterRow = jQuery('table.scale-table > tbody > tr.scale-row:first', container);
                        jQuery.each(rowLabels, function (idx, rowLabel) {
                            var rowLabelCont = masterRow.clone();
                            jQuery('div.row-label', rowLabelCont).text(rowLabel);

                            var masterCol = jQuery('td.rating-weight:first', rowLabelCont);
                            masterCol.find('input[type=radio]').attr('name', i+'_'+idx).val(ratingLabels[ratingLabels.length-1]);

                            jQuery.each(ratingLabels, function (idx2, ratingLabel) {
                                var clone = masterCol.clone();
                                clone.find('input[type=radio]')
                                     .attr('name', i+'_'+idx)
                                     .val(ratingLabel);

                                // Add to the last
                                jQuery('td.rating-weight:last', rowLabelCont).after(clone);
                            });
                            masterCol.remove();

                            // Add this to the last row
                            jQuery('table.scale-table > tbody > tr.scale-row:last', container).after(rowLabelCont);
                        });
                        masterRow.remove();

                        break;

                    case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                        container = constructQuestionItem(answerDetails.type);
                        var stars = jQuery('.stars', container).empty();
                        for(var i = 0; i < parseInt(answerDetails.nofStars); i++){
                            jQuery('.stars', container).append(jQuery('<div class="col star clickable" seq="'+i+'"></div>').click(function(){
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

//                jQuery('.questionTextContainer div', container).text(item.questionStr);
                container.attr('id',"question"+item.seq);
                container.attr('seq',item.seq);
                jQuery('.question-text', container).html("<span style='font-size:24px;color:grey;'>"+item.questionStr.charAt(0)+"</span>" + item.questionStr.substring(1));
                if (('' + item.img) != 'undefined') {
                  jQuery('img.question-pic', container).attr('src', 'data:image;base64,' + item.img);
                }
                if(i==0){
                    container.attr('hidden',false)
                }
                ttlQuestions++;
            }

        );

        }

    }

</script>

</head>

<body>
    <div class="module-header">
        <div class="title"><g:message code="takesurvey.title"/> </div>
    </div>
    <div class="module-content">
        <div class="panel panel-default">
            <div class="panel-heading" style="padding: 15px">
                <div class="media">
                        %{--<div id="surveyLogo" class="pull-left survey-logo" style="background: #4f4f4f url('../images/skin/survey-default-icon.png') no-repeat center center; background-size: 70% 70%;">--}%
                            %{--<img class="img-circle img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" style="width: 175px; height: 175px; background: url('../images/ticbox/Logo_Placeholder.png') no-repeat scroll center center #F5F5F5">--}%
                            %{--<img class="media-object img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" alt="" style="width: 100px; height: 100px; background: #4f4f4f url('../images/skin/survey-default-icon.png') no-repeat center; background-size: 70% 70%;">--}%
                            %{--<img class="media-object img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" alt="">--}%
                        %{--</div>--}%

                    <g:if test="${survey[Survey.COMPONENTS.LOGO]}">
                        %{--<img class="media-object img-responsive"--}%
                             %{--style="background: #f5f5f5; min-height: 148px; min-width: 148px;"--}%
                             %{--src="${request.contextPath}/survey/viewLogo?resourceId=${survey[Survey.COMPONENTS.LOGO]}" data-image-id="${survey[Survey.COMPONENTS.LOGO]}">--}%
                        <div id="surveyLogo" class="pull-left survey-logo" style="">
                            %{--<img class="img-circle img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" style="width: 175px; height: 175px; background: url('../images/ticbox/Logo_Placeholder.png') no-repeat scroll center center #F5F5F5">--}%
                            %{--<img class="media-object img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" alt="" style="width: 100px; height: 100px; background: #4f4f4f url('../images/skin/survey-default-icon.png') no-repeat center; background-size: 70% 70%;">--}%
                            <img class="media-object img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" alt="" style="border: 1px solid rgba(0, 0, 0, 0.1)">
                        </div>
                    </g:if>
                    <g:else>
                        %{--<img class="media-object img-responsive"--}%
                             %{--style="background: #f5f5f5 url('../images/ticbox/Logo_Placeholder.png') no-repeat center center; min-height: 148px; min-width: 148px;"--}%
                             %{--src="${request.contextPath}/survey/viewLogo?resourceId=${survey[Survey.COMPONENTS.LOGO]}" data-image-id="${survey[Survey.COMPONENTS.LOGO]}">--}%
                        <div id="surveyLogo" class="pull-left survey-logo" style="background: #4f4f4f url('../images/skin/survey-default-icon.png') no-repeat center center; background-size: 70% 70%;">
                            %{--<img class="img-circle img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" style="width: 175px; height: 175px; background: url('../images/ticbox/Logo_Placeholder.png') no-repeat scroll center center #F5F5F5">--}%
                            %{--<img class="media-object img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" alt="" style="width: 100px; height: 100px; background: #4f4f4f url('../images/skin/survey-default-icon.png') no-repeat center; background-size: 70% 70%;">--}%
                            %{--<img class="media-object img-responsive" src="${request.contextPath}/respondent/viewSurveyLogo?surveyId=${survey.surveyId}" alt="">--}%
                        </div>
                    </g:else>

                    <div class="media-body">
                        <h4 class="media-heading">
                            ${survey.name}
                        </h4>
                        <p>
                            <g:if test="${survey.title}">
                                ${survey.title}
                            </g:if>
                            <g:else>
                                <div class="module-message" style="font-size: inherit"><g:message code="surveylist.nodesc.label"/> </div>
                            </g:else>
                        </p>
                        %{--<div class="alert alert-info" style="margin-bottom: 0; font-size: 8px; width: 100%">--}%
                            %{--<g:message code="takesurvey.appreciation.label"/>--}%
                        %{--</div>--}%
                    </div>
                </div>
            </div>
            <div class="surveyItemsContainer enableTooltip panel-body">
            </div>
        </div>

        <div class="" style="padding: 0 0 3em 0;">
            <button id="lastQuestion" class="btn btn-light-oak btn-md" >Back</button>
            <button id="nextQuestion" class="btn btn-blue-trust btn-md">${g.message(code:'app.next.label')}</button>
            <button id="submitAnswers" class="btn btn-blue-trust btn-md">${g.message(code:'app.submit.label')}

        </div>

        <div class="templates" style="display: none;">

            <div id="questionTemplate" class="surveyItemContainer" hidden="true">
                <div class="row">
                    <div class="seqNumberContainer questionNumber col-xs-1"></div>
                    <div class="questionTextContainer col-xs-11">
                        <span class="question-text"></span>
                        %{--<div rows="3"></div>--}%
                        %{--<span class="media-thumbnail">--}%
                            %{--<img class="pic upload-pic question-pic" src="" />--}%
                        %{--</span>--}%
                    </div>
                </div>
            </div>

            <div id="answerTemplate-singleText" class="row answerTemplate" type="${Survey.QUESTION_TYPE.FREE_TEXT}">
                <div class="col col-xs-11 col-xs-offset-1">
                    <textarea class="place-holder-text form-control" rows="3" placeholder="${message([code: 'message.type-to-replace-place-holder', default: 'Type here to change this placeholder..'])}" maxlength="400"></textarea>
                </div>
            </div>

            <div id="answerTemplate-choice-single" class="row answerTemplate" type="${Survey.QUESTION_TYPE.CHOICE_SINGLE}">
                <div class="choice-items col-xs-11 col-xs-offset-1">
                    <div class="choice-item row">
                        <div class="col col-xs-1" style="width: 3.2%">
                        %{--<div class="col col-xs-12">--}%
                            <input class="item-check">
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
            <div id="answerTemplate-choice-multiple" class="row answerTemplate" type="${Survey.QUESTION_TYPE.CHOICE_MULTIPLE}">
                <div class="choice-items col-xs-11 col-xs-offset-1">
                    <div class="choice-item row">
                        <div class="col col-xs-1" style="width: 3.2%">
                        %{--<div class="col col-xs-12">--}%
                            <input class="item-check">
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
                                        <img class="pic upload-pic" src="" style="width: auto; height: 90px; margin-left: 0;border-radius: 5px"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="answerTemplate-scale" class="row answerTemplate" type="${Survey.QUESTION_TYPE.SCALE_RATING}">
                <div class="col col-xs-11 col-xs-offset-1" style="width:auto; overflow-x: auto;">
                    <table class="table scale-table table-bordered table-responsive">
                        <thead>
                            <tr class="scale-head">
                                <th style="text-align: center;"></th>
                                <th class="rating-label" style="text-align: center">
                                    <div></div>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                        <tr class="scale-row">
                            <td>
                                <div class="row-label"></div>
                            </td>
                            <td class="rating-weight" style="text-align: center">
                                <input type="radio" name="rd-1"/>
                            </td>
                            %{--<td></td>--}%
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="answerTemplate-starRating" class="row answerTemplate" type="${Survey.QUESTION_TYPE.STAR_RATING}">
                <div class="line stars col-xs-11 col-xs-offset-1">
                    <div class="col star clickable"></div>
                    <div class="col star clickable"></div>
                    <div class="col star clickable"></div>
                    <div class="col star clickable"></div>
                    <div class="col star clickable"></div>
                </div>
            </div>

        </div>
    </div>

<!-- validate question modal -->
<div id="validate-question-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="validateQuestionLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="validateQuestionLabel" class="modal-title">
                    <g:message code="takesurvey.answer-validation.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="validateQuestionForm" role="form">
                    <div class="well">
                        <p><b><g:message code="takesurvey.validation.no-answer.label"/> </b></p>
                        <g:message code="takesurvey.validation.no-answer.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="app.ok.label"/> </button>
            </div>
        </div>
    </div>
</div>
<!-- submit question modal -->
<div id="submit-answers-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="submitAnswersLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="submitAnswersLabel" class="modal-title">
                    <g:message code="takesurvey.answer-submit.label"/>
                </span>
            </div>
            <div class="modal-body">
                <g:form name="submitAnswersForm" role="form">
                    <div class="well">
                        <p><b><g:message code="takesurvey.validation.submit.label"/> </b></p>
                        <g:message code="takesurvey.validation.submit.content"/>
                    </div>

                </g:form>
            </div>
            <div class="modal-footer">
                <button id="saveResponse" class="btn btn-danger" data-loading-text="Processing.."><g:message code="label.button.submit"/> </button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.cancel"/> </button>
            </div>
        </div>
    </div>
</div>

</body>
</html>
