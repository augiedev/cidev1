function startMeeting(optId, mtgName, userId, userName, serverUrl, sId)
{
	if (sId) sforce.connection.sessionId = sId;
	
	var mreps = [];
	var mrep = new sforce.SObject("IBM__LL_MeetingReport__c");
	mrep.Name = mtgName;
	mrep.IBM__OpportunityId__c = optId;
	mrep.IBM__Host__c = userName;
	mreps.push(mrep);
	var result = sforce.connection.create(mreps);
	if (result[0].getBoolean("success") == false) throw "LL_MeetingReport: create failed";
	
	result = sforce.connection.retrieve("IBM__MeetingID__c", "IBM__LL_MeetingReport__c", [result[0].id]);
	if (result[0] == null) throw "LL_MeetingReport: retrieve failed";
	
	/*openIntegration(serverUrl + '/meetings/host?TagCode=extSF&TagID=' + result[0].IBM__MeetingID__c, 'height=768,width=1024,location=no,resizable=yes,toolbar=no,status=no,menubar=no,scrollbars=1', 1)*/
	openMeetingUsingPost(serverUrl + '/meetings/host', result[0].IBM__MeetingID__c);
}

function openMeetingUsingPost(host, tagId) {
		var targetUrl = host;
		var nopop = 'false';
		var popup;
		if (navigator.userAgent.indexOf('MSIE') >=0 || navigator.userAgent.indexOf('Microsoft') >= 0) {
			popup = window.open('', 'hostFilerTarget', 'channelmode=yes, scrollbars=auto, resizable=yes, location=no');
		} else {
			var adjustW = 20;
			var adjustH = 35;
			if (navigator.userAgent.indexOf('Win') >= 0) {
				adjustH = 30;
				adjustW = 0;
			}
			var width = screen.availWidth-adjustW;
			var height = screen.availHeight-adjustH;
			popup = window.open('', 'hostFilerTarget', 'width='+width+',height='+height+',scrollbars=auto,resizable=yes,location=no,toolbars=no,status=no');
		}

	    var postForm = document.createElement("form");
	    postForm.setAttribute("method", "post");
	    postForm.setAttribute("action", targetUrl);

	    var input = document.createElement('input');
	    input.type = 'hidden';
	    input.name = 'TagCode';
	    input.value = 'extSF';

	    postForm.appendChild(input);

	    input = document.createElement('input');
	    input.type = 'hidden';
	    input.name = 'TagID';
	    input.value = tagId;

	    postForm.appendChild(input);

	    document.body.appendChild(postForm);

	    if (popup) {
	    	//IE solved
	    	if (nopop != 'true') { 
		    	var isChrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
		    	if (isChrome) {
		    		if (popup.outerHeight == 0) {
			    		//Chrome blocked
			    	} else {
						postForm.setAttribute("target", "hostFilerTarget");
						popup.focus();	
			    	}
		    	} else {
					postForm.setAttribute("target", "hostFilerTarget");
					popup.focus();	
		    	}
	    	}
		}
		postForm.submit();

		return false;
	}