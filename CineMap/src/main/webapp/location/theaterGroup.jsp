<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="pack.theater.TheaterDao, pack.theater.TheaterDto" %>
<%@ page import="java.util.List" %>
<%
    String name = request.getParameter("name");
    TheaterDao dao = new TheaterDao();
    List<TheaterDto> list = dao.getTheatersByName(name);
    request.setAttribute("list", list);
    request.setAttribute("name", name);
%>

<%@ include file="/index_top.jsp" %>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/theater/theater.css">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9f8edb499be7a8316726bf8802b0fa00"></script>

<body>
<div class="container">

<c:set var="homepage" value="" />
<c:set var="logoSrc" value="" />

<c:choose>
    <c:when test="${name == 'CGV'}">
        <c:set var="homepage" value="https://www.cgv.co.kr/" />
        <c:set var="logoSrc" value="../images/cgv_logo.png" />
    </c:when>
    <c:when test="${name == '메가박스'}">
        <c:set var="homepage" value="https://www.megabox.co.kr/" />
        <c:set var="logoSrc" value="../images/megabox_logo.png" />
    </c:when>
    <c:when test="${name == '롯데시네마'}">
        <c:set var="homepage" value="https://www.lottecinema.co.kr/" />
        <c:set var="logoSrc" value="../images/lotte_logo.png" />
    </c:when>
</c:choose>

<h2>
    <c:choose>
        <c:when test="${not empty homepage}">
            <a href="${homepage}" target="_blank">
                <img src="${logoSrc}" alt="${name} 로고" style="height: 60px;">
            </a>
        </c:when>
        <c:otherwise>
            <span style="cursor: default; color: inherit;">${name} 영화관</span>
        </c:otherwise>
    </c:choose>
</h2>

<div class="theater-list">
    <c:forEach var="dto" items="${list}">
        <div class="theater-item"
             onclick="showMarker(${dto.latitude}, ${dto.longitude}, '${dto.name}', '${dto.address}')">
            🎬 ${dto.name}
        </div>
    </c:forEach>
</div>

<div class="map-image" style="display: flex; align-items: center; margin-bottom: 10px;">
    <div style="flex: 1; height: 1px; background-color: #ccc;"></div>
    <img id="theater-logo-img" src="../images/theater.gif" alt="영화관 이미지" style="margin: 0 15px; height: 40px;">
    <div style="flex: 1; height: 1px; background-color: #ccc;"></div>
</div>

<div id="map"></div>
</div>

<script>
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(37.5003928, 127.0269962),
        level: 4
    };
    var map = new kakao.maps.Map(mapContainer, mapOption);

    var currentMarker = null;
    var currentInfowindow = null;

    function showMarker(lat, lng, name, address) {
        var position = new kakao.maps.LatLng(lat, lng);

        if (currentMarker) currentMarker.setMap(null);
        if (currentInfowindow) currentInfowindow.close();

        currentMarker = new kakao.maps.Marker({
            position: position,
            map: map
        });

        currentInfowindow = new kakao.maps.InfoWindow({
            content:
                '<div style="padding:5px; width:200px; word-break:break-word; background-color:white; color:black;">' +
                '<strong>' + name + '</strong><br>' + address + '</div>'
        });

        currentInfowindow.open(map, currentMarker);
        map.setCenter(position);
        map.setLevel(4);
    }
    
    function updateThemeImages(isDarkMode) {
        const logoImg = document.getElementById("theater-logo-img");
        if (logoImg) {
            logoImg.src = isDarkMode ? "../images/theater2.gif" : "../images/theater.gif";
        }
    }
    // 페이지 로드 시 localStorage 테마 확인 → 이미지 설정
    document.addEventListener("DOMContentLoaded", function () {
        const savedTheme = localStorage.getItem("theme");
        if (savedTheme === "dark") {
            updateThemeImages(true);
        } else {
            updateThemeImages(false);
        }
    });
</script>