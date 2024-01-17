<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" type="text/css"
	href="../resources/css/mapservice.css">
<title>��å ����</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">

<!-- Script Setting -->
<script type="text/javascript" src="../resources/js/jquery-3.7.1.js"></script>
<!-- Google Web Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap"
	rel="stylesheet">

<!-- Icon Font Stylesheet -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
	rel="stylesheet">

<!-- Libraries Stylesheet -->
<link href="../resources/lib/owlcarousel/assets/owl.carousel.min.css"
	rel="stylesheet">
<link
	href="../resources/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css"
	rel="stylesheet" />

<!-- Customized Bootstrap Stylesheet -->
<link href="../resources/css/bootstrap.min.css" rel="stylesheet">

<!-- Template Stylesheet -->
<link href="../resources/css/style.css" rel="stylesheet">

<meta charset="utf-8">
<title>���� �Ÿ� ����ϱ�</title>
<style>
.dot {
	overflow: hidden;
	float: left;
	width: 12px;
	height: 12px;
	background:
		url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/mini_circle.png');
}

.dotOverlay {
	position: relative;
	bottom: 10px;
	border-radius: 6px;
	border: 1px solid #ccc;
	border-bottom: 2px solid #ddd;
	float: left;
	font-size: 12px;
	padding: 5px;
	background: #fff;
}

.dotOverlay:nth-of-type(n) {
	border: 0;
	box-shadow: 0px 1px 2px #888;
}

.number {
	font-weight: bold;
	color: #ee6152;
}

.dotOverlay:after {
	content: '';
	position: absolute;
	margin-left: -6px;
	left: 50%;
	bottom: -8px;
	width: 11px;
	height: 8px;
	background:
		url('https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white_small.png')
}

.distanceInfo {
	position: relative;
	top: 5px;
	left: 5px;
	list-style: none;
	margin: 0;
}

.distanceInfo .label {
	display: inline-block;
	width: 50px;
}

.distanceInfo:after {
	content: none;
}
</style>
</head>

<body>
<div id="map" style="width:100%;height:700px;"></div>  
<p>
    <em>������ ���콺�� Ŭ���ϸ� �� �׸��Ⱑ ���۵ǰ�<br>������ ���콺�� Ŭ���ϸ� �� �׸��Ⱑ ����˴ϴ�<br>�ڵ����� �ð��� �Ÿ��� �ԷµǸ� ���� ���� �� �� �ֽ��ϴ�</em>
    <br>
   
   <form action="pet_walk_insert" id="form" method="post"  enctype="multipart/form-data" name="walk_form">
			<div class="mb-3">
				<label for="exampleInputEmail1" class="form-label">1.�� ���̵�</label> <input
					name="pet_id" class="form-control" id="exampleInputEmail1" value="${dto.pet_id}"
					placeholder="">
			</div>
			<div class="mb-3">
			<label for="exampleInputEmail1" class="form-label" >2.��å ��¥</label>
			 <input name="walk_date" class="form-control" id="walk_date" >
			</div>
			<div class="mb-3">
			<label for="exampleInputEmail1" class="form-label">3.��å �Ÿ�</label>
			 <input name="walk_distance" class="form-control" id="walk_distance" placeholder="����"><br>
					
			</div>
			<div class="mb-3">
			<label for="exampleInputEmail1" class="form-label">4.��å �ð�</label> <input
					name="walk_time" class="form-control" id="walk_time" placeholder="��">
			</div>
			<div class="button-login-box">
				<button id="bt__ok" type="submit" class="btn btn-primary">���</button>
			</div>
		</form>
   
   
</p>


<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=56c48a3122cf3fa36b09433b2e689987"></script>
<script>



function win_close(){
	
	window.close();
}

let today = new Date();
document.getElementById("walk_date").value = today.toISOString().substring(2,10);

var mapContainer = document.getElementById('map'), // ������ ǥ���� div  
    mapOption = { 
        center: new kakao.maps.LatLng(37.4925168, 127.1236765), // ������ �߽���ǥ
        level: 2 // ������ Ȯ�� ����
    };

var map = new kakao.maps.Map(mapContainer, mapOption); // ������ �����մϴ�

var markerPosition  = new kakao.maps.LatLng(37.4925168, 127.1236765); 

//��Ŀ�� �����մϴ�
var marker = new kakao.maps.Marker({
 position: markerPosition
});

marker.setMap(map);
//��Ŀ�� ���� ���� ǥ�õ�


var drawingFlag = false; // ���� �׷����� �ִ� ���¸� ������ ���� �����Դϴ�
var moveLine; // ���� �׷����� ������ ���콺 �����ӿ� ���� �׷��� �� ��ü �Դϴ�
var clickLine // ���콺�� Ŭ���� ��ǥ�� �׷��� �� ��ü�Դϴ�
var distanceOverlay; // ���� �Ÿ������� ǥ���� Ŀ���ҿ������� �Դϴ�
var dots = {}; // ���� �׷����� ������ Ŭ���� ������ Ŭ�� ������ �Ÿ��� ǥ���ϴ� Ŀ���� �������� �迭�Դϴ�.

// ������ Ŭ�� �̺�Ʈ�� ����մϴ�
// ������ Ŭ���ϸ� �� �׸��Ⱑ ���۵˴ϴ� �׷��� ���� ������ ����� �ٽ� �׸��ϴ�
kakao.maps.event.addListener(map, 'click', function(mouseEvent) {

    // ���콺�� Ŭ���� ��ġ�Դϴ� 
    var clickPosition = mouseEvent.latLng;

    // ���� Ŭ���̺�Ʈ�� �߻��ߴµ� ���� �׸����ִ� ���°� �ƴϸ�
    if (!drawingFlag) {

        // ���¸� true��, ���� �׸����ִ� ���·� �����մϴ�
        drawingFlag = true;
        
        // ���� ���� ���� ǥ�õǰ� �ִٸ� �������� �����մϴ�
        deleteClickLine();
        
        // ���� ���� Ŀ���ҿ������̰� ǥ�õǰ� �ִٸ� �������� �����մϴ�
        deleteDistnce();

        // ���� ���� ���� �׸��� ���� Ŭ���� ������ �ش� ������ �Ÿ������� ǥ�õǰ� �ִٸ� �������� �����մϴ�
        deleteCircleDot();
    
        // Ŭ���� ��ġ�� �������� ���� �����ϰ� �������� ǥ���մϴ�
        clickLine = new kakao.maps.Polyline({
            map: map, // ���� ǥ���� �����Դϴ� 
            path: [clickPosition], // ���� �����ϴ� ��ǥ �迭�Դϴ� Ŭ���� ��ġ�� �־��ݴϴ�
            strokeWeight: 3, // ���� �β��Դϴ� 
            strokeColor: '#db4040', // ���� �����Դϴ�
            strokeOpacity: 1, // ���� �������Դϴ� 0���� 1 ���̰��̸� 0�� �������� �����մϴ�
            strokeStyle: 'solid' // ���� ��Ÿ���Դϴ�
        });
        
        // ���� �׷����� ���� �� ���콺 �����ӿ� ���� ���� �׷��� ��ġ�� ǥ���� ���� �����մϴ�
        moveLine = new kakao.maps.Polyline({
            strokeWeight: 3, // ���� �β��Դϴ� 
            strokeColor: '#db4040', // ���� �����Դϴ�
            strokeOpacity: 0.5, // ���� �������Դϴ� 0���� 1 ���̰��̸� 0�� �������� �����մϴ�
            strokeStyle: 'solid' // ���� ��Ÿ���Դϴ�    
        });
    
        // Ŭ���� ������ ���� ������ ������ ǥ���մϴ�
        displayCircleDot(clickPosition, 0);

            
    } else { // ���� �׷����� �ִ� �����̸�

        // �׷����� �ִ� ���� ��ǥ �迭�� ���ɴϴ�
        var path = clickLine.getPath();

        // ��ǥ �迭�� Ŭ���� ��ġ�� �߰��մϴ�
        path.push(clickPosition);
        
        // �ٽ� ���� ��ǥ �迭�� �����Ͽ� Ŭ�� ��ġ���� ���� �׸����� �����մϴ�
        clickLine.setPath(path);

        var distance = Math.round(clickLine.getLength());
        displayCircleDot(clickPosition, distance);
    }
});
    
// ������ ���콺���� �̺�Ʈ�� ����մϴ�
// ���� �׸����ִ� ���¿��� ���콺���� �̺�Ʈ�� �߻��ϸ� �׷��� ���� ��ġ�� �������� �����ֵ��� �մϴ�
kakao.maps.event.addListener(map, 'mousemove', function (mouseEvent) {

    // ���� ���콺���� �̺�Ʈ�� �߻��ߴµ� ���� �׸����ִ� �����̸�
    if (drawingFlag){
        
        // ���콺 Ŀ���� ���� ��ġ�� ���ɴϴ� 
        var mousePosition = mouseEvent.latLng; 

        // ���콺 Ŭ������ �׷��� ���� ��ǥ �迭�� ���ɴϴ�
        var path = clickLine.getPath();
        
        // ���콺 Ŭ������ �׷��� ������ ��ǥ�� ���콺 Ŀ�� ��ġ�� ��ǥ�� ���� ǥ���մϴ�
        var movepath = [path[path.length-1], mousePosition];
        moveLine.setPath(movepath);    
        moveLine.setMap(map);
        
        var distance = Math.round(clickLine.getLength() + moveLine.getLength()), // ���� �� �Ÿ��� ����մϴ�
            content = '<div class="dotOverlay distanceInfo">�ѰŸ� <span class="number">' + distance + '</span>m</div>'; // Ŀ���ҿ������̿� �߰��� �����Դϴ�
        document.getElementById("walk_distance").value=distance;
        // �Ÿ������� ������ ǥ���մϴ�
        showDistance(content, mousePosition);   
    }             
});                 

// ������ ���콺 ������ Ŭ�� �̺�Ʈ�� ����մϴ�
// ���� �׸����ִ� ���¿��� ���콺 ������ Ŭ�� �̺�Ʈ�� �߻��ϸ� �� �׸��⸦ �����մϴ�
kakao.maps.event.addListener(map, 'rightclick', function (mouseEvent) {

    // ���� ������ Ŭ�� �̺�Ʈ�� �߻��ߴµ� ���� �׸����ִ� �����̸�
    if (drawingFlag) {
        
        // ���콺����� �׷��� ���� �������� �����մϴ�
        moveLine.setMap(null);
        moveLine = null;  
        
        // ���콺 Ŭ������ �׸� ���� ��ǥ �迭�� ���ɴϴ�
        var path = clickLine.getPath();
    
        // ���� �����ϴ� ��ǥ�� ������ 2�� �̻��̸�
        if (path.length > 1) {

            // ������ Ŭ�� ������ ���� �Ÿ� ���� Ŀ���� �������̸� ����ϴ�
            if (dots[dots.length-1].distance) {
                dots[dots.length-1].distance.setMap(null);
                dots[dots.length-1].distance = null;    
            }

            var distance = Math.round(clickLine.getLength()), // ���� �� �Ÿ��� ����մϴ�
                content = getTimeHTML(distance); // Ŀ���ҿ������̿� �߰��� �����Դϴ�
                
            // �׷��� ���� �Ÿ������� ������ ǥ���մϴ�
            showDistance(content, path[path.length-1]);  
             
        } else {

            // ���� �����ϴ� ��ǥ�� ������ 1�� �����̸� 
            // ������ ǥ�õǰ� �ִ� ���� �������� �������� �����մϴ�.
            deleteClickLine();
            deleteCircleDot(); 
            deleteDistnce();

        }
        
        // ���¸� false��, �׸��� �ʰ� �ִ� ���·� �����մϴ�
        drawingFlag = false;          
    }  
});    

// Ŭ������ �׷��� ���� �������� �����ϴ� �Լ��Դϴ�
function deleteClickLine() {
    if (clickLine) {
        clickLine.setMap(null);    
        clickLine = null;        
    }
}

// ���콺 �巡�׷� �׷����� �ִ� ���� �ѰŸ� ������ ǥ���ϰ�
// ���콺 ������ Ŭ������ �� �׸��� ������� �� ���� ������ ǥ���ϴ� Ŀ���� �������̸� �����ϰ� ������ ǥ���ϴ� �Լ��Դϴ�
function showDistance(content, position) {
    
    if (distanceOverlay) { // Ŀ���ҿ������̰� ������ �����̸�
        
        // Ŀ���� ���������� ��ġ�� ǥ���� ������ �����մϴ�
        distanceOverlay.setPosition(position);
        distanceOverlay.setContent(content);
        
    } else { // Ŀ���� �������̰� �������� ���� �����̸�
        
        // Ŀ���� �������̸� �����ϰ� ������ ǥ���մϴ�
        distanceOverlay = new kakao.maps.CustomOverlay({
            map: map, // Ŀ���ҿ������̸� ǥ���� �����Դϴ�
            content: content,  // Ŀ���ҿ������̿� ǥ���� �����Դϴ�
            position: position, // Ŀ���ҿ������̸� ǥ���� ��ġ�Դϴ�.
            xAnchor: 0,
            yAnchor: 0,
            zIndex: 3  
        });      
    }
}

// �׷����� �ִ� ���� �ѰŸ� ������ 
// �� �׸��� ������� �� ���� ������ ǥ���ϴ� Ŀ���� �������̸� �����ϴ� �Լ��Դϴ�
function deleteDistnce () {
    if (distanceOverlay) {
        distanceOverlay.setMap(null);
        distanceOverlay = null;
    }
}

// ���� �׷����� �ִ� ������ �� ������ Ŭ���ϸ� ȣ���Ͽ� 
// Ŭ�� ������ ���� ���� (���׶�̿� Ŭ�� ���������� �ѰŸ�)�� ǥ���ϴ� �Լ��Դϴ�
function displayCircleDot(position, distance) {

    // Ŭ�� ������ ǥ���� ���� ���׶�� Ŀ���ҿ������̸� �����մϴ�
    var circleOverlay = new kakao.maps.CustomOverlay({
        content: '<span class="dot"></span>',
        position: position,
        zIndex: 1
    });

    // ������ ǥ���մϴ�
    circleOverlay.setMap(map);

    if (distance > 0) {
        // Ŭ���� ���������� �׷��� ���� �� �Ÿ��� ǥ���� Ŀ���� �������̸� �����մϴ�
        var distanceOverlay = new kakao.maps.CustomOverlay({
            content: '<div class="dotOverlay">�Ÿ� <span class="number">' + distance + '</span>m</div>',
            position: position,
            yAnchor: 1,
            zIndex: 2
        });

        // ������ ǥ���մϴ�
        distanceOverlay.setMap(map);
    }

    // �迭�� �߰��մϴ�
    dots.push({circle:circleOverlay, distance: distanceOverlay});
}

// Ŭ�� ������ ���� ���� (���׶�̿� Ŭ�� ���������� �ѰŸ�)�� �������� ��� �����ϴ� �Լ��Դϴ�
function deleteCircleDot() {
    var i;

    for ( i = 0; i < dots.length; i++ ){
        if (dots[i].circle) { 
            dots[i].circle.setMap(null);
        }

        if (dots[i].distance) {
            dots[i].distance.setMap(null);
        }
    }

    dots = [];
}

// ���콺 ��Ŭ�� �Ͽ� �� �׸��Ⱑ ������� �� ȣ���Ͽ� 
// �׷��� ���� �ѰŸ� ������ �Ÿ��� ���� ����, ������ �ð��� ����Ͽ�
// HTML Content�� ����� �����ϴ� �Լ��Դϴ�
function getTimeHTML(distance) {

    // ������ �ü��� ��� 4km/h �̰� ������ �м��� 67m/min�Դϴ�
    var walkkTime = distance / 67 | 0;
    var walkHour = '', walkMin = '';

    // ����� ���� �ð��� 60�� ���� ũ�� �ð����� ǥ���մϴ�
    
    walkMin = '<span class="number">' + walkkTime + '</span>��'
    document.getElementById("walk_time").value=walkkTime;
    // �������� ��� �ü��� 16km/h �̰� �̰��� �������� �������� �м��� 267m/min�Դϴ�
    var bycicleTime = distance / 227 | 0;
    var bycicleHour = '', bycicleMin = '';

    // ����� ������ �ð��� 60�� ���� ũ�� �ð����� ǥ���մϴ�
    if (bycicleTime > 60) {
        bycicleHour = '<span class="number">' + Math.floor(bycicleTime / 60) + '</span>�ð� '
    }
    bycicleMin = '<span class="number">' + bycicleTime % 60 + '</span>��'

    // �Ÿ��� ���� �ð�, ������ �ð��� ������ HTML Content�� ����� �����մϴ�
    var content = '<ul class="dotOverlay distanceInfo">';
    content += '    <li>';
    content += '        <span class="label">�ѰŸ�</span><span class="number">' + distance + '</span>m';
    content += '    </li>';
    content += '    <li>';
    content += '        <span class="label">����</span>' + walkHour + walkMin;
    content += '    </li>';
    content += '    <li>';
    content += '        <span class="label">������</span>' + bycicleHour + bycicleMin;
    content += '    </li>';
    content += '</ul>'

    return content;
}
</script>
</body>
</html>