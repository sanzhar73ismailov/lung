/**
 * файл для работы с формами
 */

var debug = false; // если true то сообщения будут выводиться в консоль
// для вывода сообщения на консоль
var general_count = 0; // для отработки, счетчик для выходы из бесконечных циклов

function console_log(str) {
    if (debug)
        console.log(str);
}
function requiredRadiosOn(name){
	var normRadioEls = document.getElementsByName(name);
	for(var i = 0; i < normRadioEls.length; i++){
	   normRadioEls[i].required = true;
	   normRadioEls[i].disabled = false;
	}
}

function requiredRadiosOff(name){
	var normRadioEls = document.getElementsByName(name);
	for(var i = 0; i < normRadioEls.length; i++){
	   normRadioEls[i].required = false;
	   normRadioEls[i].disabled = true;
	}
}

/**
 *  Делает элемент с указанным id обязательным, присваивая класс, меняет подсветку на розовую
 * @param elId
 */
function requiredOn(elId){
	var inputEl = document.getElementById(elId);
	inputEl.required = true;
	inputEl.className = "req_input";
	//inputEl.disabled = false;
	
}
/**
 *  Делает элемент с указанным id необязательным, убирая класс, меняет подсветку на белую
 * @param elId
 */

function requiredOff(elId){
	var inputEl = document.getElementById(elId);
	inputEl.required = false;
	inputEl.className = "";
	//inputEl.disabled = true;
	//inputEl.value = ""; // решил, что значения пусть остаются, вдруг чел решил включить
}

/**
 * Отображает соответствующий div на форме и все входящие туда переключатели (radio) делает обязательными
 */
function showChildDivAndSetRequired(divId) {
	var divElement = document.getElementById(divId);
	general_count = 0;
	divElement.style.display = "";
	document.getElementById(divId+"_mark").innerHTML = "-";
	setChildsRadioiRequired(divElement.childNodes, true);
}

/**
 * Скрывает соответствующий div на форме и все входящие туда переключатели (radio) делает необязательными
 */
function hideChildDivAndSetRequired(divId) {
	var divElement = document.getElementById(divId);
	general_count = 0;
	divElement.style.display = "none";
	document.getElementById(divId+"_mark").innerHTML = "+";
	setChildsRadioiRequired(divElement.childNodes, false);
}

/**
 * Прочесывает в рекурсии все элементы и если находит там переключатели (<input type='radio'/>) 
 * делает их обязательными или необязательными (параметр requiredValue)
 * @param chNodes - массив элементов
 * @param requiredValue - обязательность для заполнения (булево)
 * @returns
 */
function setChildsRadioiRequired(chNodes, requiredValue) {
	if(general_count++ > 1000) 
		return;
	for (var i = 0; i < chNodes.length; i++) {
		console.log("chNodes.length: " + chNodes.length);
		chNode = chNodes[i];
		console_log("nodeName: " + chNode.nodeName, "nodeType: " + chNode.nodeType);
		if (chNode.nodeType == 1) { // если тип узла элемент
			console_log("tagName: " + chNode.tagName);
			if (chNode.tagName == "INPUT") {
				if (chNode.type == "radio") {
					console_log("name: " + chNode.name);
					chNode.required = requiredValue;
					continue;
				}
			}
			if (chNode.hasChildNodes()) {
				setChildsRadioiRequired(chNode.childNodes, requiredValue);
			}
		}
		// txt = txt + c[i].nodeName + "<br>";
	}
}
