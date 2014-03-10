<%--
  Created by IntelliJ IDEA.
  User: arnold
  Date: 4/13/13
  Time: 9:56 PM
--%>

<%@ page import="ticbox.Survey" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="surveyor"/>
    <title></title>

    <style type="text/css">


    </style>

    <script type="text/javascript">

        var ttlQuestions = 0;

        jQuery(function() {
            console.log('~ BEGIN jQuery function');
            jQuery('#surveyorProfileContent').addClass('out');
            jQuery('#surveyInfoAccordion').show();
            jQuery('#surveyInfoContainer').addClass('out');

            jQuery('#uploadLogoBtn').click(function(){
                jQuery('.qq-upload-button > input')
                        .attr('accept', 'image/*')
                        .trigger('click');
            });

            jQuery('#pickLogoBtn').click(function(){
                logoId = jQuery('input.logoResourceId:checked').val();

                if (logoId) {
                    jQuery('#surveyLogo > img').attr('src', '${request.contextPath}/survey/viewLogo?resourceId='+logoId);
                    jQuery('#chooseLogoModal').modal('hide');
                }
            });

            jQuery('.surveyItemTypeAdd').click(function(){
                console.log('~ surveyItemTypeAdd.clicked');
                var type = jQuery(this).attr('type');
                var subtype = jQuery(this).attr('subtype');

                constructQuestionItem(type, subtype);

            });

            jQuery('#saveSurveyBtn').click(function(){

                var questionItems = buildQuestionItemsMap();

                submitSurvey(questionItems);

            });

            jQuery('#surveyTitle').val('${survey.title}');

            jQuery.getJSON('${request.contextPath}/survey/getQuestionItems', {}, function(questionItems){

                loadSurvey(questionItems);

            });

//            jQuery('#surveyPreviewModal').on('shown', function(){
            jQuery('#surveyPreviewModal').on('shown.bs.modal', function(){
                console.log('~ BEGIN #surveyPreviewModal.onShown');
                var questionItems = buildQuestionItemsMap();
                constructPreview(questionItems);

//            }).on('hidden', function(){
            }).on('hidden.bs.modal', function(){
                jQuery('#surveyPreviewModal .modal-body').empty();
            })/*.css({
                'width': function () {
                    return ($(document).width() * .8) + 'px';
                },
                'margin-left': function () {
                    return -($(this).width() / 2);
                }
            })*/;

//            jQuery('#chooseLogoModal').on('show', function(){
            jQuery('#chooseLogoModal').on('show.bs.modal', function(){

                if(jQuery('#chooseLogoModal .modal-body').html().trim() == ''){ //TODO .is(:empty) doesn't work -___-'
                    jQuery.getJSON('${request.contextPath}/survey/getLogoIds', {}, function(data){

                        jQuery('#chooseLogoModal .modal-body').empty();
                        jQuery.each(data, function(idx, id){
                            populateLogoImageResources(id);
                        });

                    });
                }

                if (logoId) {
                    jQuery('input.logoResourceId[value="'+ logoId +'"]', jQuery('#chooseLogoModal')).next('a').trigger('click'); //TODO to accommodate prettyCheckable
                }

//            }).on('hide', function(){
            }).on('hide.bs.modal', function(){

                        //TODO

            });

        });

        var logoId = null;

        function populateLogoImageResources(id){
            var logoWrapper = jQuery('.templates .logoWrapper').clone().appendTo(jQuery('#chooseLogoModal .modal-body'));
            jQuery('.logoImg', logoWrapper).attr('src', "${request.contextPath}/survey/viewLogo?resourceId="+id).click(function(){
                //jQuery('input[name="logoResourceId"]', logoWrapper).prop('checked', true);
                jQuery('input.logoResourceId', logoWrapper).next('a').trigger('click'); //TODO to accommodate prettyCheckable
            });
            jQuery('input.logoResourceId', logoWrapper).val(id).prettyCheckable();
        }

        function constructQuestionItem(type, subtype){
            var answerComp = null;

            var changeTypeIconClass = '';

            switch(type){

                case '${Survey.QUESTION_TYPE.CHOICE}' :

                    answerComp = jQuery('#answerTemplate-choice').clone().removeAttr('id');

                    if (subtype == 'single') {
                        jQuery('.choice-type', answerComp).val('single');

                        changeTypeIconClass = 'single-choice-icon';
                    }else if (subtype == 'multiple') {
                        jQuery('.choice-type', answerComp).val('multiple');

                        changeTypeIconClass = 'multiple-choice-icon';
                    }

                    jQuery('.add-item', answerComp).click(function(){
                        var newItem = jQuery('.choice-item:first', '#answerTemplate-choice').clone();
                        jQuery('.item-label', newItem).val('');

                        newItem.appendTo(jQuery('.choice-items', answerComp));

                        jQuery('input.item-check', newItem).click(function(){
                            newItem.remove();
                        });
                    });

                    break;

                case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                    answerComp = jQuery('#answerTemplate-singleText').clone().removeAttr('id');
                    changeTypeIconClass = 'free-text-icon';

                    break;

                case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                    answerComp = jQuery('#answerTemplate-scale').clone().removeAttr('id');

                    jQuery('.add-row', answerComp).click(function(){
                        var row = jQuery('.scale-row:first', answerComp).clone();
                        jQuery('table', answerComp).append(row);
                        jQuery('.rating-weight > input', row).attr('name', 'rd-'+jQuery('.scale-row',answerComp).size());
                    });

                    jQuery('.add-rating', answerComp).click(function(){
                        var ratingLabel = jQuery('.rating-label', '#answerTemplate-scale').clone();
                        jQuery(this).parent().before(ratingLabel);

                        jQuery('.scale-row', answerComp).each(function(idx){
                            var ratingWeight = jQuery('.rating-weight', '#answerTemplate-scale').clone();
                            jQuery('.rating-weight:last', jQuery(this)).after(ratingWeight);
                            jQuery('input', ratingWeight).attr('name', jQuery('.rating-weight > input:first',ratingWeight.parent()).attr('name'));
                        });
                    });

                    changeTypeIconClass = 'scale-rating-icon';

                    break;

                case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                    answerComp = jQuery('#answerTemplate-starRating').clone().removeAttr('id');
                    changeTypeIconClass = 'star-rating-icon';

                    jQuery('.add-star', answerComp).click(function(){
                        if (jQuery('.stars .star', answerComp).length < 10) {
                            jQuery('.stars', answerComp).append(jQuery('<div class="col star"></div>'));
                        }
                    });

                    jQuery('.remove-star', answerComp).click(function(){
                        if (jQuery('.stars .star', answerComp).length > 3) {
                            jQuery('.stars .star:first', answerComp).remove();
                        }
                    });


                    break;

            }

            var questionComp = jQuery('#questionTemplate').clone().removeAttr('id').append(answerComp).appendTo('.surveyItemsContainer');

            jQuery('.change-question-type-btn', questionComp).addClass(changeTypeIconClass);

            jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(idx){
                jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
            });

            jQuery('.surveyItemActions .remove', questionComp).click(function(){
                jQuery(this).parents('.surveyItemContainer').remove();
                jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(idx){
                    jQuery('.questionNumber', jQuery(this)).html(idx + 1 + '.');
                });
            });

            return questionComp;
        }

        function buildQuestionItemsMap(){
            console.log('~ BEGIN buildQuestionItemsMap');
            var questionItems = [];
            var seq = 0;

            jQuery('.surveyItemsContainer > .surveyItemContainer').each(function(){
                console.log('~ BEGIN .surveyItemsContainer > .surveyItemContainer each');

                var container = jQuery(this);
                var type = jQuery('.answerTemplate', container).attr('type');
                var questionStr = jQuery('.questionTextContainer > textarea', container).val();
                var answerDetails = {};
                answerDetails['type'] = type;

                switch(type){

                    case '${Survey.QUESTION_TYPE.CHOICE}' :
                        console.log('~ type is choice');
                        answerDetails['choiceItems'] = [];
                        jQuery('.choice-items > .choice-item', container).each(function(){

                            var item = jQuery(this);
                            answerDetails['choiceItems'].push(jQuery('input.item-label', item).val());
                        });

                        answerDetails['choiceType'] = jQuery('select.choice-type', container).val();

                        break;

                    case '${Survey.QUESTION_TYPE.FREE_TEXT}' :
                        answerDetails['questionPlaceholder'] = jQuery('textarea.place-holder-text', container).val();
                        console.log('~ type is free text, answerDetails: ' + answerDetails['questionPlaceholder']);
                        break;

                    case '${Survey.QUESTION_TYPE.SCALE_RATING}' :
                        console.log('~ type is scale rating');

                        answerDetails['ratingLabels'] = [];
                        jQuery('table.scale-table > thead .rating-label input', container).each(function(){

                            answerDetails['ratingLabels'].push(jQuery(this).val());

                        });

                        answerDetails['rowLabels'] = [];
                        jQuery('table.scale-table > tbody input.row-label', container).each(function(){

                            answerDetails['rowLabels'].push(jQuery(this).val());

                        });

                        break;

                    case '${Survey.QUESTION_TYPE.STAR_RATING}' :
                        answerDetails['nofStars'] = jQuery('.stars .star', container).length;
                        console.log('~ type is star rating, answerDetails: ' + answerDetails['nofStars']);
                        break;

                }

                questionItems.push({
                    seq : ++seq,
                    questionStr : questionStr,
                    answerDetails : answerDetails
                });

            });

            return questionItems
        }

        function submitSurvey(questionItems){

            jQuery.post('${request.contextPath}/survey/submitSurvey', {questionItems: JSON.stringify(questionItems), surveyTitle: jQuery('#surveyTitle').val(), logoResourceId:logoId}, function(data){

                if('SUCCESS' == data){
                    alert('Submission success..');
                }else{
                    alert('Submission failure');
                }

            });
        }

        function loadSurvey(questionItems){

            if (questionItems) {

                jQuery.each(questionItems, function(idx, item){

                    var answerDetails = item.answerDetails;
                    var container = null;

                    switch(answerDetails.type){

                        case '${Survey.QUESTION_TYPE.CHOICE}' :

                            var choiceItems = answerDetails.choiceItems;
                            var choiceType = answerDetails.choiceType;

                            container = constructQuestionItem(answerDetails.type, choiceType);

                            jQuery.each(choiceItems, function(idx, choiceItem){
                                var choiceItemCont = jQuery('.choice-items > .choice-item:first', container).clone();
                                jQuery('.choice-items', container).append(choiceItemCont);
                                jQuery('.item-label', choiceItemCont).val(choiceItem);

                                jQuery('input.item-check', choiceItemCont).click(function(){
                                    choiceItemCont.remove();
                                });
                            });
                            jQuery('.choice-items > .choice-item:first', container).remove();

                            jQuery('select.choice-type', container).val(choiceType);

                            break;

                        case '${Survey.QUESTION_TYPE.FREE_TEXT}' :

                            var questionPlaceHolder = answerDetails.questionPlaceholder;

                            container = constructQuestionItem(answerDetails.type);

                            jQuery('textarea.place-holder-text', container).val(questionPlaceHolder);

                            break;

                        case '${Survey.QUESTION_TYPE.SCALE_RATING}' :

                            var ratingLabels = answerDetails.ratingLabels;
                            var rowLabels = answerDetails.rowLabels;

                            container = constructQuestionItem(answerDetails.type);

                            jQuery.each(ratingLabels, function(idx, ratingLabel){
                                var ratingLabelCont = jQuery('table.scale-table > thead th.rating-label:first', container).clone();
                                jQuery('table.scale-table > thead > tr.scale-head > th.rating-label:last', container).after(ratingLabelCont);
                                jQuery('input', ratingLabelCont).val(ratingLabel);
                            });
                            jQuery('table.scale-table > thead th.rating-label:first', container).remove();

                            jQuery.each(rowLabels, function(idx, rowLabel){
                                var rowLabelCont = jQuery('table.scale-table > tbody > tr.scale-row:first', container).clone();
                                jQuery('table.scale-table > tbody', container).append(rowLabelCont);
                                jQuery('input.row-label', rowLabelCont).val(rowLabel);
                                for(var i = 1; i < ratingLabels.length; i++){
                                    jQuery('td.rating-weight:first', rowLabelCont).after(jQuery('td.rating-weight:first', rowLabelCont).clone());
                                }
                            });
                            jQuery('table.scale-table > tbody > tr.scale-row:first', container).remove();

                            break;

                        case '${Survey.QUESTION_TYPE.STAR_RATING}' :

                            container = constructQuestionItem(answerDetails.type);

                            var stars = jQuery('.stars', container).empty();
                            for(var i = 0; i < parseInt(answerDetails.nofStars); i++){
                                stars.append(jQuery('<div class="col star clickable" seq="'+i+'"></div>'));
                            }

                            break;

                    }

                    jQuery('.questionTextContainer textarea', container).val(item.questionStr);

                });

            }

        }

        function constructPreview(questionItems){
            console.log('~ BEGIN constructPreview');
            jQuery.each(questionItems, function(idx, item){

                var questionStr = item.questionStr;
                var answerDetails = item.answerDetails;

                var questionTemplate = jQuery('#questionPreviewTemplate').clone().removeAttr('id');

                jQuery('.seqNumberContainer', questionTemplate).html(idx+1+'.');

                jQuery('.question-text', questionTemplate).html("<span style='font-size:24px;color:grey;'>"+questionStr.charAt(0)+"</span>" + questionStr.substring(1));

                var answerTemplate = null;

                switch(answerDetails.type){

                    case '${Survey.QUESTION_TYPE.CHOICE}' :

                        var choiceItems = answerDetails.choiceItems;
                        var choiceType = answerDetails.choiceType;

                        switch(choiceType){

                            case 'multiple' :

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
                            case 'single' :

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
                        }

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

    </script>

    <r:require module="fileuploader" />

</head>
<body>

<div class="module">
    <div class="module-header">
        <div class="title">
            <span style="color: black; font-weight: normal">Edit Survey: </span>
            <span style="text-transform: uppercase">${survey.name}</span>
        </div>
    </div>
    <div class="module-content">
        <div class="panel panel-default">
            <div class="panel-heading" style="padding: 20px 15px">
                <div class="media">
                    <div id="surveyLogo" class="pull-left clickable survey-logo" data-toggle="modal" href="#chooseLogoModal">
                        <img class="media-object img-responsive"
                             style="background: #f5f5f5 url('../images/ticbox/Logo_Placeholder.png') no-repeat center center; min-height: 148px; min-width: 148px;"
                             src="${request.contextPath}/survey/viewLogo?resourceId=${survey[Survey.COMPONENTS.LOGO]}" >
                    </div>
                    <div class="media-body">
                        <span style="font-size: 18px;">
                            <g:message code="label.survey.survey-generator.survey-title" default="Describe Your Survey"/>
                        </span>
                        <div>
                            <textarea id="surveyTitle" rows="4" class="form-control" style="resize: none; margin: 14px 10px 0 0"></textarea>
                        </div>
                    </div>
                </div>
            </div>
            <div class="surveyItemsContainer enableTooltip panel-body" style="padding: 20px 15px 20px 10px">
            </div>

        %{--<div class="line rowLine10">--}%
            %{--<div class="col col10">--}%
                %{--<div id="surveyLogo" class="clickable" data-toggle="modal" href="#chooseLogoModal" style="width: 250px; height: 150px; background: #f5f5f5 url('../images/ticbox/Logo_Placeholder.png') no-repeat center">--}%
                    %{--<img src="${request.contextPath}/survey/viewLogo?resourceId=${survey[Survey.COMPONENTS.LOGO]}" style="width: 250px; height: 150px">--}%
                %{--</div>--}%
            %{--</div>--}%
            %{--<div class="col" style="width: 400px; height: auto; vertical-align: bottom; display: inline-block; color: #97b11a; padding-top: 20px;">--}%
                %{--<div class="line">--}%
                    %{--<span style="font-size: 18px; line-height: 40px">--}%
                        %{--<g:message code="label.survey.survey-generator.survey-title" default="Your survey title here"/>--}%
                    %{--</span>--}%
                    %{--<textarea id="surveyTitle" style="width: 350px; display: inline-block; resize: none;"></textarea>--}%
                %{--</div>--}%
            %{--</div>--}%
        %{--</div>--}%

        <div style="display: none">
            <uploader:uploader id="imageUploader" url="${[controller:'survey', action:'uploadLogo']}" params="${[:]}" sizeLimit="512000"> %{--allowedExtensions="['jpeg', 'png', 'gif']"--}%
                <uploader:onComplete>
                    if(responseJSON.resourceId){
                        populateLogoImageResources(responseJSON.resourceId);
                    }else{
                        alert(responseJSON.message);
                    }
                </uploader:onComplete>
            </uploader:uploader>
        </div>

        %{--<div class="surveyItemsContainer enableTooltip line10">--}%

        %{--</div>--}%

        %{--<div class="line line-centered">--}%

    </div>

    <div id="buttonBarHeader" class="module-header"></div>
        <div id="buttonBarContent" class="module-content">
            <button class="btn btn-sm btn-light-oak link" href="${request.contextPath}/survey/respondentFilter"><g:message code="label.button.back" default="Back"/></button>
            <button id="saveSurveyBtn" class="btn btn-sm btn-green"><g:message code="label.button.save" default="Save"/></button>
            <button id="finalizeSurveyBtn" class="btn btn-sm btn-blue-trust link" href="${request.contextPath}/survey/finalizeAndPublishSurvey"><g:message code="label.button.finalize" default="Finalize and Publish"/></button>
        </div>
    </div>
</div>

<div id="menuNavPanelContent">

    <div id="questionTypesMenuContainer" class="side-panel">
        <div id="questionTypesItemContainer">
            <ul>
                <li class="surveyItemTypeAdd single-choice clickable" type="${Survey.QUESTION_TYPE.CHOICE}" subtype="single"></li>
                <li class="surveyItemTypeAdd multiple-choice clickable" type="${Survey.QUESTION_TYPE.CHOICE}" subtype="multiple"></li>
                <li class="surveyItemTypeAdd single-text clickable" type="${Survey.QUESTION_TYPE.FREE_TEXT}"></li>
                <li class="surveyItemTypeAdd scale clickable" type="${Survey.QUESTION_TYPE.SCALE_RATING}"></li>
                <li class="surveyItemTypeAdd star-rating clickable" type="${Survey.QUESTION_TYPE.STAR_RATING}"></li>

                %{--<li id="questionTypesTitleContainer"></li>--}%
                <li id="questionTypesDynamicTitleContainer">
                    <span id="question-type-title">Question Type</span>
                    <span id="single-choice-title">Single Choice</span>
                    <span id="multiple-choice-title" style="font-size: 1em !important;">Multiple Choice</span>
                    <span id="free-text-title">Free Text</span>
                    <span id="scale-title">Scale Rating</span>
                    <span id="star-rating-title">Star Rating</span>
                </li>
            </ul>
        </div>
    </div>

    <div class="" style="width: 100%">
        <div class="line line-centered">
            <button style="border-radius: 8px; width: 100%;" href="#surveyPreviewModal" role="button" data-toggle="modal" class="btn btn-lg btn-blue-trust" type="button"><g:message code="label.button.preview" default="Quick Preview"/> Survey</button>
        </div>
    </div>

</div>

<div class="templates" style="display: none;">

    <div id="questionTemplate" class="surveyItemContainer">
        <div class="row" style="position: relative">
            <div class="seqNumberContainer questionNumber col-xs-1"></div>
            <div class="col-xs-11">
                <div class="questionTextContainer">
                    <textarea class="form-control" style="padding: 6px 12px; word-wrap: break-word" rows="3" placeholder="${message([code: 'message.type-to-set-question', default: 'Type your question here..'])}" ></textarea>
                    <div class="question-action-btn change-question-type-btn" style="position: absolute;right: 10px;top: 8px;"></div>
                </div>
                <div class="surveyItemActions" style="float: left; padding: 1px 0 0 5px">
                    %{--<div>--}%
                    %{--<button class="btn video" data-toggle="tooltip" data-placement="top" title="Upload video"><i class="icon-play"></i></button>--}%
                    %{--<div class="question-action-btn change-question-type-btn" style="display: inline-block"></div>--}%
                    %{--<button class="btn remove" data-toggle="tooltip" data-placement="top" title="Remove"><i class="icon-remove"></i></button>--}%
                    %{--<div class="remove question-action-btn delete-question-icon clickable" style="display: inline-block"></div>--}%
                    %{--</div>--}%
                    %{--<div>--}%
                    %{--<button class="btn picture" data-toggle="tooltip" data-placement="top" title="Upload picture"><i class="icon-camera"></i></button>--}%
                    <div class="question-action-btn upload-pic-icon clickable" style="margin: 0 0 0 0"></div>
                    %{--<button class="btn remove" data-toggle="tooltip" data-placement="top" title="Remove"><i class="icon-remove"></i></button>--}%
                    <div class="question-action-btn upload-vid-icon clickable" style="margin: 3px 0 0 0"></div>
                    %{--</div>--}%
                </div>
            </div>
            <div class="surveyItemActions" style="position: absolute; right: 10px;top: 0;">
                <div class="remove question-action-btn delete-question-icon clickable"></div>
            </div>
        </div>

    </div>

    <div id="answerTemplate-singleText" class="answerTemplate row" type="${Survey.QUESTION_TYPE.FREE_TEXT}">
        <div class="col col-xs-11 col-xs-offset-1">
            <textarea class="place-holder-text form-control answerTextContainer" rows="3" placeholder="${message([code: 'message.type-to-replace-place-holder', default: 'Type here to change this placeholder..'])}"></textarea>
        </div>
    </div>

    <div id="answerTemplate-choice" class="answerTemplate row" type="${Survey.QUESTION_TYPE.CHOICE}">

        <div class="choice-items col col-xs-11 col-xs-offset-1">
            <div class="choice-item row" style="margin-bottom: 3px">
                    <input class="item-check" type="checkbox" checked style="height: 34px">
                    <input class="item-label form-control" type="text" placeholder="${message([code: 'message.type-to-set-label', default: 'Type here to set label..'])}">
                    <div class="col" style="float: left; padding: 1px 0 0 5px">
                        %{--<button class="btn" data-toggle="tooltip" data-placement="right" title="Upload picture"><i class="icon-camera"></i></button>--}%
                        %{--<div style="width: 20px; height: 100%; cursor: pointer; background: transparent url('../images/ticbox/06_Question_UploadIcon_Picture.png') no-repeat center"></div>--}%
                        <div class="question-action-btn upload-pic-icon clickable" style="margin: 0 0 0 0"></div>
                    </div>
            </div>
        </div>
        <div class="form-group col col-xs-11 col-xs-offset-1" style="clear: both; width: 100%; padding: 5px 15px 0">
            <div class="col" style="display: none;">
                <select class="choice-type">
                    <option value="single">Single Choice</option>
                    <option value="multiple">Multiple Choice</option>
                </select>
            </div>
            <div class="col">
                <button class="btn btn-default btn-info add-item"><i class="glyphicon glyphicon-plus"></i> New Item</button>
            </div>
        </div>
    </div>

    <div id="answerTemplate-scale" class="answerTemplate row" type="${Survey.QUESTION_TYPE.SCALE_RATING}">
        %{--<div class="col col-xs-12" style="height:auto; overflow-x: auto; max-width: 600px;">--}%
        <div class="col col-xs-11 col-xs-offset-1">
            <div class="scale-table-container" style="overflow-x: auto;">
                %{--<div class="seqNumberContainer">&nbsp;</div>--}%
                <table class="survey-generator-table table scale-table table-responsive" style="width: auto">
                    <thead>
                        <tr class="scale-head">
                            <th style="text-align: left; width: 100px;">
                                <button class="btn btn-default btn-info add-row">
                                    <i class="glyphicon glyphicon-plus"></i> Add Row
                                </button>
                            </th>
                            <th class="rating-label" style="text-align: left">
                                <input type="text" class="input-small form-control" placeholder="Rating label.." style="width: 100px;">
                            </th>
                            <th>
                                <button class="btn btn-default btn-info add-rating">
                                    <i class="glyphicon glyphicon-plus"></i> Add Rating
                                </button>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="scale-row">
                            <td style="max-width: 100px;">
                                <input type="text" class="row-label input-small form-control" placeholder="Row label.." style="width: 100%;">
                            </td>
                            <td class="rating-weight" style="text-align: center">
                                <input type="radio" name="rd-1">
                            </td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="answerTemplate-starRating" class="answerTemplate row" type="${Survey.QUESTION_TYPE.STAR_RATING}">
        <div class="line stars col col-xs-11 col-xs-offset-1">
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
            <div class="col star clickable"></div>
        </div>
        <div class="line col col-xs-11 col-xs-offset-1 form-group" style="clear: both; width: 100%; padding: 5px 15px 0">
            <div class="col" style="margin-right: 5px">
                <button class="btn btn-default btn-info remove-star">
                    <i class="glyphicon glyphicon-minus"></i>
                </button>
            </div>
            <div class="col">
                <button class="btn btn-default btn-info add-star">
                    <i class="glyphicon glyphicon-plus"></i>
                </button>
            </div>
        </div>
    </div>

    %{--Preview Templates--}%

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

    <div id="answerPreviewTemplate-starRating" class="answerTemplate row" type="${Survey.QUESTION_TYPE.STAR_RATING}">
        <div class="line stars col-xs-11 col-xs-offset-1">

        </div>
    </div>

    <div class="logoWrapper col">
        <div class="col clickable" style="border: 1px solid #cccccc; border-radius: 10px; width: 263px">
            <img class="logoImg" src="" style="width: 100%; border-radius:10px">
        </div>
        <div class="line line-centered" style="margin: 10px auto;">
            <input type="radio" name="logoResourceId" class="logoResourceId">
        </div>
    </div>

</div>

<!-- Preview Modal -->
<div id="surveyPreviewModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="surveyPreviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="surveyPreviewModalLabel" class="modal-title" >Survey Preview</span>
            </div>
            <div class="modal-body" style="overflow: auto; padding: 20px 50px 20px 20px">

            </div>
            <div class="modal-footer">
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

%{--Upload image resource modal--}%
<div id="chooseLogoModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="chooseLogoModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <span id="chooseLogoModalLabel" class="modal-title">
                    Choose your logo or upload a new one
                </span>
            </div>
            <div class="modal-body" style="overflow: auto">
            </div>
            <div class="modal-footer">
                <button id="pickLogoBtn" class="btn btn-light-oak">Pick</button>
                <button id="uploadLogoBtn" class="btn btn-green">Upload</button>
                <button class="btn btn-light-oak" data-dismiss="modal" aria-hidden="true"><g:message code="label.button.close" default="Close"/></button>
            </div>
        </div>
    </div>
</div>

</body>
</html>