function hideButton() {

    var buttonOrder = document.getElementsByName('create_purchase_order');
    var buttonDesign = document.getElementsByName('invisimount_design');
    var standard = true;

    console.log('found design buttons: ' + buttonDesign.length);
    var doms = document.getElementsByClassName('labelCol');
    var status = '';
    for (var i = 0; i < doms.length; i++) {
        if (doms[i].tagName == 'TD' && doms[i].innerHTML == 'Design Status') {

            console.log('child: ' + doms[i].nextSibling.childNodes[0].innerHTML);
            if ( doms[i].nextSibling.childNodes[0].innerHTML === undefined ){
                status = doms[i].nextSibling.innerHTML;
                standard = false;
            }
            else {
                status = doms[i].nextSibling.childNodes[0].innerHTML;
            }
            console.log('status: ' + status);
        }
    }

    if (standard){
        // These are existing functions
        oldOnLoad();
        pca_load();        
    }

    if (status == 'InvisiMount Design Pending') {
        for (i = 0; i < buttonOrder.length; i++) {
            buttonOrder[i].style.display = 'none';
        }
    } else {
        for (i = 0; i < buttonDesign.length; i++) {
            buttonDesign[i].style.display = 'none';
        }
    }

}

window.onload = hideButton;
