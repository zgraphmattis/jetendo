
(function($, window, document, undefined){
	"use strict";
	var zCart=function(options){
		var self=this;
		var $cartDiv=false;
		var idOffset=0;
		var count=0;
		var cartLoaded=false;
		var items={};
		var itemIds={};
		if(typeof options === undefined){
			options={};
		}
		/* TODO Only store the ids in cookie, when user clicks on View, load the data from ajax request.
		 * setInterval to read the cookie because other browser windows are able to change it and this window would appear out of date. use setInterval to do this.
		 */
		
		// force defaults
		options.arrData=zso(options, 'arrData', false, []);
		options.debug=zso(options, 'debug', false, false);
		options.name=zso(options, 'name', false, '');
		options.label=zso(options, 'label', false, 'cart');
		options.emptyCartMessage=zso(options, 'emptyCartMessage', false, 'Nothing has been added to your cart.');
		options.selectedButtonText=zso(options, 'selectedButtonText', false, 'Already in cart');
		options.checkoutCallback=zso(options, 'checkoutCallback', false,  function(){self.checkout(); }); 
		options.changeCallback=zso(options, 'changeCallback', false, function(){});
		
		function init(options){
			$cartDiv=$(".zcart."+options.name);
			if($cartDiv.length === 0){
				throw(options.name+" is not defined.  zCart requires a valid object or selector for the cart items to be rendered in.");
			}
			// setup mouse events for add and remove buttons for this cart's name only.
			$(".zcart-add."+options.name).bind('click', function(){
				var jsonObj=eval("("+this.getAttribute("data-zcart-json")+")"); 
				self.add(jsonObj);
				return false;
			}).each(function(){
				var jsonObj=eval("("+this.getAttribute("data-zcart-json")+")");
				this.setAttribute("data-zcart-id", jsonObj.id);
				
				if(zKeyExists(itemIds, jsonObj.id)){
					$(this).addClass("zcart-add-saved");
					$(this).html(jsonObj.removeHTML);
				}
			});
			$(".zcart-remove."+options.name).bind('click', function(){
				var itemId=this.getAttribute("data-zcart-id");
				self.remove(itemId);
				return false;
			});
			$(".zcart-refresh."+options.name).bind('click', function(){
				self.renderItems();
				return false;
			});
			$(".zcart-view."+options.name).bind('click', function(){
				if($(this).hasClass("zcart-view-open")){
					$(this).removeClass("zcart-view-open");
					$(this).html(this.getAttribute("data-zcart-viewHTML"));
				}else{
					$(this).addClass("zcart-view-open");
					$(this).html(this.getAttribute("data-zcart-hideHTML"));
				}
				self.view();
				return false;
			});
			$(".zcart-checkout."+options.name).bind('click', function(){
				self.checkout();
				return false;
			});
			$(".zcart-clear."+options.name).bind('click', function(){
				self.clear();
				return false;
			});
			self.readCookie();
			self.updateCount(); 
			cartLoaded=true;
		};
		self.view=function(){
			$cartDiv.slideToggle("fast");
		};
		self.renderCount=function(){ 
			if(typeof options.countRenderCallback === "function"){
				options.countRenderCallback(count);
				return;
			}
			$(".zcart-count."+options.name).html(count);
		};
		self.getItems=function(){
			return items;
		};
		self.readCookie=function(){
			var value=zGetCookie("zcart-"+options.name);
			if(value === ""){
				return;
			}
			var arrId=value.split(",");
			if(options.debug) console.log("From cookie:"+arrId.join("|"));
			for(var i in arrId){
				if(arrId[i] !== ""){
					if(options.debug) console.log("Added from cookie: "+options.arrData[arrId[i]].id);
					self.add(options.arrData[arrId[i]]);
				}
			} 
		};
		self.updateCookie=function(){
			var arrId=[];
			for(var i in items){
				arrId.push(items[i].id);
			}
			zSetCookie({key:"zcart-"+options.name,value:arrId.join(","),futureSeconds:31536000,enableSubdomains:true}); 
		};
		self.updateCount=function(){
			if(options.debug) console.log("count is:"+count);
			if(count===0){
				$cartDiv.html(options.emptyCartMessage);
			}
			self.updateCookie();
			self.renderCount();
			if(cartLoaded){
				options.changeCallback(self);
				$(".zcart-count-container."+options.name).css({
					"background-color": "#000",
					"color": "#FFF"
				}).animate({
					"background-color": "#FFF",
					"color": "#000"
				}, 
				{
					duration:'slow',
					easing:'easeInElastic'
				});
				}
		};
		self.getCount=function(){
			return count;
		}
		self.add=function(jsonObj){
			// mark all other "add" buttons as saved too if their id matches.
			if(zKeyExists(itemIds, jsonObj.id)){ 
				self.remove(jsonObj.id);
				return;
			}else{
				$(".zcart-add."+options.name).each(function(){
					if(!$(this).hasClass("zcart-add-saved")){
						var tempJsonObj=eval("("+this.getAttribute("data-zcart-json")+")"); 
						if(jsonObj.id === tempJsonObj.id){
							$(this).addClass("zcart-add-saved").html(tempJsonObj.removeHTML);
						}
					}
				});
			}
			
			idOffset++;
			count++;
			if(options.debug) console.log('Adding item #'+jsonObj.id+" to cart: "+options.name);
			var itemString=self.renderItem(jsonObj, idOffset); 
			if(count===1){
				$cartDiv.html(itemString);
			}else{
				$cartDiv.append(itemString);
			}
			$('#'+options.name+'zcart-item-delete-link'+idOffset).bind('click', function(){
				var itemId=this.getAttribute("data-zcart-id");
				self.remove(itemId);
				return false;
			});
			$("#"+options.name+"zcart-item"+idOffset).hide().fadeIn('fast');
			jsonObj.cartId=idOffset;
			jsonObj.div=document.getElementById(options.name+"zcart-item"+idOffset);
			items[idOffset]=jsonObj;
			itemIds[jsonObj.id]=idOffset; 
			self.updateCount();
		};
		self.remove=function(itemId){
			if(!zKeyExists(itemIds, itemId)){
				return;
			}
			var id=itemIds[itemId];
			if(options.debug) console.log('Removing item #'+itemId+" to cart: "+options.name);   
			delete items[id];
			delete itemIds[itemId];
			
			$(".zcart-add."+options.name).each(function(){
				if($(this).hasClass("zcart-add-saved")){
					var tempJsonObj=eval("("+this.getAttribute("data-zcart-json")+")"); 
					if(itemId === tempJsonObj.id){
						$(this).removeClass("zcart-add-saved").html(tempJsonObj.addHTML);
					}
				}
			});
			
			$("#"+options.name+"zcart-item"+id).fadeOut('fast',
				function(){
					$("#"+options.name+"zcart-item"+id).remove();
				}
			);
			count--;
			self.updateCount();
		}; 
		self.replaceTags=function(html, obj){
			for(var i in obj){
				var regEx=new RegExp("{"+i+"}", "gm"); 
				html=html.replace(regEx, zHtmlEditFormat(obj[i]));
			}
			return html;
		};
		self.renderItem=function(obj, id){
			var arrR=[];
			var itemTemplate=$(".zcart-templates .zcart-item");
			if(itemTemplate.length===0){
				throw(".zcart-template .zcart-item template is missing and it's required.");
			}
			itemTemplate=itemTemplate[0].outerHTML;
			var tempObj={};
			for(var i in obj){
				tempObj[i]=obj[i];
			}
			tempObj.itemId=options.name+'zcart-item'+id;
			tempObj.deleteId=options.name+'zcart-item-delete-link'+id;
			var newHTML=$(self.replaceTags(itemTemplate, tempObj));
			$(".zcart-item-image", newHTML).each(function(){
				var a=this.getAttribute("data-image");
				if(a !== ""){
					this.setAttribute("src", a);
				}
			});
			$("a", newHTML).each(function(){
				this.href=this.getAttribute("data-url");
			});
			newHTML.addClass(options.name);
			return newHTML[0].outerHTML;
		};
		self.renderItems=function(){
			var arrItems=[];
			for(var i in items){
				arrItems.push(self.renderItem(items[i], items[i].cartId));
			}
			$cartDiv.html(arrItems).hide().fadeIn('fast');
			self.updateCount();
		};
		self.ajaxAddCallback=function(){

		};
		self.ajaxAdd=function(){

		};
		self.clear=function(){
			items=[];
			itemIds=[]; 
			count=0;
			idOffset=0;
			$(".zcart-add."+options.name).each(function(){
				if($(this).hasClass("zcart-add-saved")){
					var tempJsonObj=eval("("+this.getAttribute("data-zcart-json")+")"); 
					$(this).removeClass("zcart-add-saved").html(tempJsonObj.addHTML);
				}
			});
			
			$(".zcart-item."+options.name).fadeOut('fast',
				function(){
					if ($(".zcart-item."+options.name+":animated").length === 0){
						$cartDiv.html("");
						self.updateCount();
					}
				}
			);
		};
		self.checkout=function(){
			// for listing inquiry, I pass comma separated obj.id
		// need a callback function for
			if(typeof options.checkoutCallback === "function"){
				options.checkoutCallback(self);
				return;
			}
			if(options.debug) console.log("No checkout callback defined.");
		};
		init(options);
		return this;
	}; 
	window.zCart=zCart;
})(jQuery, window, document, "undefined"); 
