	var gup = function(name){

	    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
	    var regexS = "[\\?&]" + name + "=([^&#]*)";
	    var regex = new RegExp(regexS);
	    var results = regex.exec(window.location.href);
	    if (results == null)
	        return "";
	    else
	        return results[1];
	}


	var addslashes = function(str){
		return str;
	}

/*

highlight v3

Highlights arbitrary terms.

<http://johannburkard.de/blog/programming/javascript/highlight-javascript-text-higlighting-jquery-plugin.html>

MIT license.

Johann Burkard
<http://johannburkard.de>
<mailto:jb@eaio.com>

*/


jQuery.fn.highlight = function(pat) {
 function innerHighlight(node, pat) {
  var skip = 0;
  if (node.nodeType == 3) {
   var pos = addslashes(node.data).toUpperCase().indexOf(addslashes(pat));
   if (pos >= 0) {
    var spannode = document.createElement('span');
    spannode.className = 'highlight';
    var middlebit = node.splitText(pos);
    var endbit = middlebit.splitText(addslashes(pat).length);
    var middleclone = middlebit.cloneNode(true);
    spannode.appendChild(middleclone);
    middlebit.parentNode.replaceChild(spannode, middlebit);
    skip = 1;
   }
  }
  else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
   for (var i = 0; i < node.childNodes.length; ++i) {
    i += innerHighlight(node.childNodes[i], pat);
   }
  }
  return skip;
 }
 return this.each(function() {
  innerHighlight(this, pat.toUpperCase());
 });
};

jQuery.fn.removeHighlight = function() {
 return this.find("span.highlight").each(function() {
  this.parentNode.firstChild.nodeName;
  with (this.parentNode) {
   replaceChild(this.firstChild, this);
   normalize();
  }
 }).end();
};

/**
 ** AUTHOR LOOKUP PAGE VARS && METHODS
 **
 **/
	var searchStr;
	var highlightSearchString = function (){
		if (searchStr != ''){
			$('.resultList td.highlightable').highlight(searchStr);
		}
	}

	function nameSelected(idSelected,nameSelected){

		window.opener.setLookupName(idSelected,nameSelected,lkUptype);
		window.close();
	}

	function searchByName(){
		searchStr = $.trim($('#search_criteria').val());
		var type= '';
		if (lkUptype=='3'){
			type ='Groups\'s';
		}else{
			type ='Author\'s';
		}


		if (searchStr == ''){
			alert(type+ ' '+nameCannotBeEmpty);
		}else{
			search($.trim($('#search_criteria').val()));
		}

	}

	function displayAll(){
		$('#search_criteria').val('');
		searchStr = '';
		search('');
		$('.resultList td.highlightable').removeHighlight();
	}
	
	function cleanField(fieldId){
		$('#'+fieldId).val('');
	}
// --------------------------------------- EOF!
/**
 ** ITEM DETAIL PAGE
 **
 **/
var highlightSearchStringItemDetail = function (searchStr){
		var searchStr = gup('searchStr');
			if (searchStr != ''){
				$('div.listRelatedObject').highlight(searchStr);
			}
	}
// --------------------------------------- EOF!

//----------- Purge/Search Common Methods

function searchLock(){
		editButton('searchBtn', loadingText,true);
}

function searchUnlock(){
		enableSearchBtn(buttonSearchText);
}


function editButton(btnId, btnText,disabledValue){
		var element = $('input#'+btnId);
		 $(element).val(btnText);
		 $(element).attr("disabled", disabledValue);
	}

function enableSearchBtn(msj){
  		editButton('searchBtn', msj,false);
}
  	function enableExportBtn(msj){
  		editButton('exportBtn', msj,false);
}


//---------------------chatter audit PURGE vars and methods
function initPurge(){
		
		initPublicPrivateMsgButton();
		
		$.datepicker._setTime = function(inst, date) {
			var tp_inst = this._get(inst, 'timepicker');
			if (tp_inst) {
				var defaults = tp_inst._defaults,
					// calling _setTime with no date sets time to defaults
					hour = date ? date.getHours() : defaults.hour,
					minute = date ? date.getMinutes() : defaults.minute,
					second = date ? date.getSeconds() : defaults.second,
					millisec = date ? date.getMilliseconds() : defaults.millisec;

				//check if within min/max times..
				if ((hour < defaults.hourMin || hour > defaults.hourMax) || (minute < defaults.minuteMin || minute > defaults.minuteMax) || (second < defaults.secondMin || second > defaults.secondMax) || (millisec < defaults.millisecMin || millisec > defaults.millisecMax)) {
					hour = defaults.hourMin;
					minute = defaults.minuteMin;
					second = defaults.secondMin;
					millisec = defaults.millisecMin;
				}

				tp_inst.hour = hour;
				tp_inst.minute = minute;
				tp_inst.second = second;
				tp_inst.millisec = millisec;

				if (tp_inst.hour_slider) tp_inst.hour_slider.slider('value', hour);
				if (tp_inst.minute_slider) tp_inst.minute_slider.slider('value', minute);
				if (tp_inst.second_slider) tp_inst.second_slider.slider('value', second);
				if (tp_inst.millisec_slider) tp_inst.millisec_slider.slider('value', millisec);

				tp_inst._onTimeChange();
				tp_inst._updateDateTime(inst);
			}
		};
		
		$.datepicker._base_gotoToday = $.datepicker._gotoToday;
		$.datepicker._gotoToday = function(id) {
			var inst = this._getInst($(id)[0]),
				$dp = inst.dpDiv;
			this._base_gotoToday(id);
			var now = new Date();
			var tp_inst = this._get(inst, 'timepicker');
			if (tp_inst && tp_inst._defaults.showTimezone && tp_inst.timezone_select) {
				var tzoffset = now.getTimezoneOffset(); // If +0100, returns -60
				var tzsign = tzoffset > 0 ? '-' : '+';
				tzoffset = Math.abs(tzoffset);
				var tzmin = tzoffset % 60;
				tzoffset = tzsign + ('0' + (tzoffset - tzmin) / 60).slice(-2) + ('0' + tzmin).slice(-2);
				if (tp_inst._defaults.timezoneIso8609)
					tzoffset = tzoffset.substring(0, 3) + ':' + tzoffset.substring(3);
				tp_inst.timezone_select.val(tzoffset);
			}
			this._setTime(inst, now);
			$( '.ui-datepicker-today', $dp).click(); 
		};

		$( ".datepicker" ).datepicker({
			dateFormat: "yy-mm-dd",
			showButtonPanel: true,
			closeText: 'Clear',
    		showOn: "both",
    		changeMonth: true,
			changeYear: true,
			buttonImage: calendarImgUrl,
			buttonImageOnly: true,
			buttonText: " Date select "
		});
		$(".datepicker").attr("readOnly", true);
		$('#startDate').datepicker('widget').delegate('.ui-datepicker-close', 'mouseup', function() {
			$('#startDate').val('');
		});

		$('#endDate').datepicker('widget').delegate('.ui-datepicker-close', 'mouseup', function() {
			$('#endDate').val('');
		});
		//initial values


		$('input#searchBtn').click(function(){
			editButton('searchBtn', 'Searching...',true);
			submitFilterRecords();
		});

		$('input#exportBtn').click(function(){
			editButton('exportBtn', 'Purging...',true);
			confirmPurge();
		});
}


function submitFilterRecords() {
		var error = false;
		var stDate = $("#startDate").datepicker("getDate");
		var endDate = $("#endDate").datepicker("getDate");
		itmsCount = 0;
		if (stDate != null && endDate!= null ){
			if (stDate.getTime() > endDate.getTime()){
				alert(invalidDateRange);
				error = true;
				enableSearchBtn(buttonSearchText);
			}
		}else{
			alert(invalidDateRange);
			error = true;
			enableSearchBtn(buttonSearchText);
		}

		if (! error){
			getPurgeList($('#startDate').val(),$('#endDate').val() );
		}else{
			$('#exportBtn').attr("disabled",false);
		}
	}

function confirmPurge(){

		var error = false;

		if (itmsCount == "0" || ( $('#startDate').val() == "" || $('#endDate').val() == "")){
			alert(ammountOfRecords);
			error = true;
		}

		if(!error){
			if(confirm(confirmDialog_deleteRecords)){
				purgeResults($('#startDate').val(),$('#endDate').val(),$('input[name=exportFormat]:checked').val() );
			}
		}else{
			enableExportBtn(textSubmitButton);
		}		
}


function initPublicPrivateMsgButton(){
	$('.typeOfSearch').click(function() {
		$('.typeOfSearch').removeClass('typeOfSearchSelected');
		$(this).addClass('typeOfSearchSelected');
		arrangeScreen($(this).attr("screen"));
		$("#list2").jqGrid('GridUnload');
		var optionSelected = $(this).attr("screen");
		if ( optionSelected == "sp" ){
			privateMessagesJqGrid();
		}else{
			publicMessagesJqGrid();
		}		
	});
}

//-----------------------CHATTER AUDIT SEARCH page vars and methods
function initSearch(){
	arrangeScreen( $('input:radio[name=involving]:checked').val() );

		initPublicPrivateMsgButton();
		
		$('input:radio[name=involving]').click(function(){
			arrangeScreen( $(this).val() );
		});

		$('.bSelected').hover(function(){
			$(this).removeClass('chatterAuditButton');
			$(this).addClass('chatterAuditButtonHover');
		},function(){
			$(this).removeClass('chatterAuditButtonHover');
			$(this).addClass('chatterAuditButton');
		})


		$('.postOptionsLink').click(function(){
			var state = $('.postOptions').css("display");
			if ( state == "block" ){
				$('.postOptionsLink').html('[+]');
	 			$('.postOptions').slideToggle('350', function(){});
			}else{
	 			//$('.postOptions').fadeIn();
	 			$('.postOptions').slideToggle('350', function(){});
	 			$('.postOptionsLink').html('[-]');
			}
		})

		$('.postOptionsLink').hover(function(){
			$(this).html( $(this).html()+' <font size=\"1\">click to expand/collapse</font>' );
		},function(){
			$(this).html( $(this).html().replace('<font size=\"1\">click to expand/collapse</font>','') );

		});

		$('.otherOptionsLink').click(function(){
			var state = $('.otherOptions').css("display");
			if ( state == "block" ){
				$('.otherOptionsLink').html('[+]');
	 			$('.otherOptions').fadeOut();
			}else{
	 			$('.otherOptions').fadeIn();
	 			$('.otherOptionsLink').html('[-]');
			}
		})


		$( ".datepicker" ).datetimepicker({
			dateFormat: "yy-mm-dd",
			showButtonPanel: true,
			closeText: 'Clear',
    		showOn: "both",
    		changeMonth: true,
			changeYear: true,
			buttonImage: calendarImgUrl,
			buttonImageOnly: true,
			buttonText: " Date select "
		});
		$(".datepicker").attr("readOnly", true);
		$('#startDate').datepicker('widget').delegate('.ui-datepicker-close', 'mouseup', function() {
			$('#startDate').val('');
		});
		$('#endDate').datepicker('widget').delegate('.ui-datepicker-close', 'mouseup', function() {
			$('#endDate').val('');
		});

		$('input#searchBtn').click(function(){
			editButton('searchBtn', 'Searching...',true);
			doSearch();
		});

		$('input#exportBtn').click(function(){
			exportData();
		});
}

function exportData(){
		if (itmsCount >0 ){
			exportResult($('input[name=exportFormat]:checked').val());
		}else{
			alert(noRecordsToExport);
		}
}


function arrangeScreen(msj){

		if ( msj == 's0' ){
  			allPeopleScreen();
  		}else
  		if ( msj == 's1' ){
  			onePeopleScreen();
  		}else if( msj == 's2'){
  			twoPeopleScreen();
  		}else if( msj == 's3'){
  			groupScreen();
  		}else if( msj == 'sp'){
  			privateMessagesScreen();
  		}
}
function allPeopleScreen(){
		$('.userContainer').hide();
  		//$('.personOneContainer').hide();
  		//$('.personTwoContainer').hide();
  		$('.groupContainer').hide();
  		$('.checkboxesTwoPersonContainer').hide();
  		$('.checkboxesOnePersonContainer').hide();
  		$('.involving').show();
		$('.datesPicker').show();
		$('.inputExportFullDiv').show();
  		cleanFields();
}

function onePeopleScreen(){
  		$('.userContainer').show();
  		$('.personOneContainer').show();
  		$('.personTwoContainer').hide();
  		$('.groupContainer').hide();
  		$('.checkboxesTwoPersonContainer').hide();
  		$('.checkboxesOnePersonContainer').show();
  		$('.involving').show();
		$('.datesPicker').show();
		$('.inputExportFullDiv').show();
  		cleanFields();
}

function twoPeopleScreen(){
		$('.userContainer').show();
  		$('.personOneContainer').show();
  		$('.personTwoContainer').show();
  		$('.groupContainer').hide();
  		$('.checkboxesTwoPersonContainer').show();
  		$('.checkboxesOnePersonContainer').hide();
  		$('.involving').show();
		$('.datesPicker').show();
		$('.inputExportFullDiv').show();
  		cleanFields();
}

function groupScreen(){
  		$('.userContainer').hide();
  		$('.personOneContainer').hide();
  		$('.personTwoContainer').hide();
  		$('.groupContainer').show();
  		$('.checkboxesTwoPersonContainer').hide();
  		$('.checkboxesOnePersonContainer').hide();
  		$('.involving').show();
		$('.datesPicker').show();
		$('.inputExportFullDiv').show();
  		cleanFields();
}

function privateMessagesScreen(){
		//Cleaning the involving section to avoid errors in options
		$('input:radio[name=involving]:first').attr("checked",true);
		allPeopleScreen();
		$('.userContainer').show();
		$('.personOneContainer').show();
		$('.personTwoContainer').show();
		$('.groupContainer').hide();
		$('.checkboxesTwoPersonContainer').hide();
		$('.checkboxesOnePersonContainer').hide();
		$('.involving').hide();
		$('.datesPicker').show();
		$('.inputExportFullDiv').hide();
		$('input[name="exportFormat"][value="csvQuick"]').attr('checked', true);
		cleanFields();
}

function cleanFields(){
  		$('input:#itemInsertedByName').val("");
  		$('input:#itemInsertedByNameTwo').val("");
  		$('input:#itemGroupName').val("");
  		$('.spanlookupHidden input#itemInsertedById').val("");
  		$('.spanlookupHidden2 input#itemInsertedByIdTwo').val("");
  		$('.spanlookupHidden3 input#itemGroupId').val("");
  		$('#startDate').val("");
  		$('#endDate').val("");
}

/* User look Up methods  */
function setLookupName(idSelected,nameSelected,from){

		if (from =='1' ){
			$('.spanlookupHidden input#itemInsertedById').val(idSelected);
			$('input#itemInsertedByName').val(nameSelected);
		}else if (from =='2' ){
			$('.spanlookupHidden2 input#itemInsertedByIdTwo').val(idSelected);
			$('input#itemInsertedByNameTwo').val(nameSelected);
		}else if (from =='3' ){
			$('.spanlookupHidden3 input#itemGroupId').val(idSelected);
			$('input#itemGroupName').val(nameSelected);
		}
}

function displayLookUp(from){

		var uName;
		if (from =='1' ){
			uName = $.trim($('#itemInsertedByName').val());
		}if (from =='2' ){
			uName = $.trim($('#itemInsertedByNameTwo').val());
		}if (from =='3' ){
			uName = $.trim($('#itemGroupName').val());
		}
		var wUrl = authorLookupUrl;

		window.open(wUrl+'?uName='+uName+'&type='+from,'xxx','scrollbars=1,status=1,menubar=0,resizable=0,location=0,width=450,height=450,top=120,left=700');

}

/* search */
function doSearch() {

		var publicOrPrivateSearch = $('.typeOfSearchSelected').attr("type") == undefined ? "public" : $('.typeOfSearchSelected').attr("type");
		var bodyText 		= $.trim($('#itemBody').val());
		bodyText.replace(/([\&amp;\|\!\(\)\{\}\[\]\^~\:\\\+\-])/g, "\\$1")
		var groupName 	= $.trim($('#itemGroupId').val());
		var error = false;
		var startDate 	= $('#startDate').val();
		var endDate 	= $('#endDate').val();
		var searchScenario 	= $('input:radio[name=involving]:checked').val();
		var firstId 		= $.trim($('input#itemInsertedById').val());
		var secondId 		= $.trim($('input#itemInsertedByIdTwo').val());
		var s1opt1 = $('input:checkbox[name=s1opt1]').attr('checked');
		var s1opt2 = $('input:checkbox[name=s1opt2]').attr('checked');
		var s1opt3 = $('input:checkbox[name=s1opt3]').attr('checked');
		var s1opt4 = $('input:checkbox[name=s1opt4]').attr('checked');
		var s2opt1 = $('input:checkbox[name=s2opt1]').attr('checked');
		var s2opt2 = $('input:checkbox[name=s2opt2]').attr('checked');
		var params = new Object();
		//validations
		if ( bodyText.length ==1 ){
			alert(atLeastTwoChars);
			error = true;
		}else
		if ( bodyText.length >1000 ){
			alert(atMostThousandChars);
			error = true;
		}

		params["itemBody"] = bodyText;

		if (searchScenario=='s1'){
			if ( firstId ==''){
				alert(choosAUser);
				error = true;
			}else if( ! $('input:checkbox[name=s1opt1]').attr('checked') &&
				! $('input:checkbox[name=s1opt2]').attr('checked') &&
				! $('input:checkbox[name=s1opt3]').attr('checked') &&
				! $('input:checkbox[name=s1opt4]').attr('checked')  ){

				alert(choosAnOption);
				error = true;
			}
		}



		if (searchScenario=='s2'){
			if ( firstId =='' || secondId ==''){
				alert(choosAPair);
				error = true;
			}else if (	! $('input:checkbox[name=s2opt1]').attr('checked') &&
						! $('input:checkbox[name=s2opt2]').attr('checked')){

				alert(choosAnOption);
				error = true;
			}
		}
		if (searchScenario=='s3' && groupName ==''){
			alert(choosAGroup);
			error = true;
		}

		if (!error) {
			itmsCount =0;
				
			params["s1opt1"] = s1opt1;
			params["s1opt2"] = s1opt2;
			params["s1opt3"] = s1opt3;
			params["s1opt4"] = s1opt4;
			params["s2opt1"] = s2opt1;
			params["s2opt2"] = s2opt2;
			params["startD"] = startDate.replace(" ", "_");
			params["endD"] = endDate.replace(" ", "_");
			params["scenario"] = searchScenario;
			params["userId1"] = firstId;
			params["userId2"] = secondId;
			params["groupName"] = groupName;
			params["typeOfSearch"] = publicOrPrivateSearch;
			
			searchServer( params );

			searchStr		= bodyText;

		}else{
			enableSearchBtn(buttonSearchText);
		}
}

function checkOption(value){
    	$('div.typeDivOptions').hide();
    	$('#itemLinkDetails').val('');
    	if (value =='LinkPost'){
    		$('div#LinkPostDetails').show();
    	}
}

function pagingCallback(action){
		highlightSearchStringSearchPage();
}

var highlightSearchStringSearchPage = function (){
		if (searchStr != ''){
			$('td.textBody').highlight(searchStr);
		}
}

function dialogExportedData(msj){
	alert(msj);
}

/* functions to formatting cells  the result table */
function wrapTxtFmt(ArrayValue, opts, rowData){
	return ArrayValue != null ? ArrayValue.length > 120 ? ArrayValue.substr(0,120)+"..." : ArrayValue : "";
}

//CONFIG PAGE JS
function configSetup(){
	$('.ownerIdContainer').text( (ownerId == null ? "OWNER NOT SET UP" : "OWNER: "+ownerId) );
	$('#dataLoadedId').attr("checked", (prevChatterDataLoaded == "true" ? true : false) );
	$('#deleteBlockerId').attr("checked", (contentBlocker == "true" ? true : false) );
	if (pmFreq != null || pmFreq != undefined) $('.slcts option[value=\"'+Math.floor(pmFreq)+'\"]').attr("selected",true);
	$('.pmCurrentUpdateFreq').text( (pmFreq == null ? " CURRENT FREQUENCY NOT SET UP " : "CURRENT FREQUENCY: "+Math.floor(pmFreq)+" Hour/s") );
	if (batchFreq != null || batchFreq != undefined) $('.slctsBatchCG option[value=\"'+Math.floor(batchFreq)+'\"]').attr("selected",true);		
	$('.batchStatus').text( batchStatus == 'true' ? 'Stop Batch' : 'Start Batch' );
}
		
function showLoading(){		
	$('<div class=\"showing_load\">Saving...<img src=\"/img/loading32.gif\"/></div>')
	.css({
		'width'             : '100px',
		'position'          : 'fixed',
		top                 : function(index){ return $(window).height()/2 },
		left                : function(){ return $(window).width()/2-50 }
		})
	.appendTo('body');
		$('<div class=\"showing_load_layer\"></div>')
		.css({
		height                 : function(index){ return $(window).height() },
		width                  : function(){ return $(window).width() }			
		})
	.appendTo('body');					
}
		
function hideLoading(){
	$('.showing_load').remove();
	$('.showing_load_layer').remove();
}

function doChanges(o1,o2,o3,o4){ showLoading(); doChangesAF(o1,o2,o3,o4); }
function resetLastExecution(){ showLoading(); resetLastExecutionAF(); }
function startStopBatch(o1) { showLoading(); startStopBatchAF(o1); }
function requestComplete(){ configSetup(), hideLoading(); }