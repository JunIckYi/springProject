<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page trimDirectiveWhitespaces="true" %>



<script type="text/javascript">
   $(function(){
	  
      /*검색 후 검색 대상과 검색 단어 출력 */
      let word="<c:out value='${boardVO.keyword}' />";
      let value="";
      
      if(word!=""){
         $("#keyword").val("<c:out value='${boardVO.keyword}' />");
         $("#search").val("<c:out value='${boardVO.search}' />");
         
         if($("#search").val()!='b_content'){
            //:contains()는 특정 텍스트를 포함한 요소 반환
            if($("#search").val()=='b_title') value = "#list tr td.goDetail";
            else if($("#search").val()=='b_name') value="#list tr td.name";
            console.log($(value+":contains('"+word+"')").html());
            
            //$("#list tr td.goDetail:contains('노력')").html() => <span class='required'>노력</span>에 대한 명언
            $(value+":contains('"+word+"')").each(function(){
               let regex = new RegExp(word, 'gi');
               $(this).html($(this).html().replace(regex,"<span class='required'>"+word+"</span>"));
            });
         }
      }

	   
      
      /* 입력 양식 enter 제거 */
      $("#keyword").bind("keydown", function(event) {
         if(event.keyCode == 13) {
            event.preventDefault();
         }
      });
      
      /* 검색 대상이 변경될 때마다 처리 이벤트 */
      $("#search").change(function(){
         if($("#search").val()=="all") {
            $("#keyword").val("전체 목록 조회합니다");
         }else if($("#search").val()!="all"){
            $("#keyword").val("");
            $("#keyword").focus();
         }
      });
      
      /* 검색 버튼 클릭 시 처리 이벤트 */
      $("#searchData").click(function(){
         if($("#search").val()!="all"){   //제목/내용/작성자 선택시 검색어 유효성 체크
            if(!chkData("#keyword", "검색어를")) return;
         }
         $("#pageNum").val(1); //페이지 초기화
         goPage();
      })
   
      $("#insertFormBtn").click(function(){
           location.href="/board/writeForm";
        });
        
        /* 제목 클릭 시 살세 페이지 이동을 위한 처리 이벤트 */
      $(".goDetail").click(function(){
           let b_num = $(this).parents("tr").attr("data-num");
           $("#b_num").val(b_num);
           console.log("글번호 : "+b_num);
           //세세 페이지로 이동하기위해 form추가 (id=: detailForm)
           $("#detailForm").attr({
              "method" : "get",
              "action" : "/board/boardDetail"
           });
           $("#detailForm").submit();
        });
        
        $(".paginate_button a").click(function(e){
        	e.preventDefault();
        	$("#f_search").find("input[name='pageNum']").val($(this).attr("href"));
        	goPage();
        })
        
   });   //$함수 종료문
   
   /* 검색을 위한 실질적인 처리 함수 */
   function goPage(){
      if($("#search").val()=="all") {
         $("#keyword").val("");
      }
      
      $("#f_search").attr({
         "method" : "get",
         "action" : "/board/boardList"
      });
      $("#f_search").submit();
   }

</script>




</head>
<body>

   <div class="container">
      <form id="detailForm">
         <input type="hidden" id="b_num" name="b_num" />
      </form>
      
      <%--============================= 검색 기능 시작 ============================== --%>
      <div id="boardSearch" class="text-right">
         <form id="f_search" name="f_search" class="form-inline">
       <%--페이징 처리를 위한 파라미터  --%>
	       <input type="hidden" name="pageNum" id="pageNum" value="${pageMaker.cvo.pageNum}">
	       <input type="hidden" name="amount" id="amount" value="${pageMaker.cvo.amount}">
            <div class="form-group">
               <label>검색조건</label>
               <select id="search" name="search" class="form-control">
                  <option value="all">전체</option>
                  <option value="b_title">제목</option>
                  <option value="b_content">내용</option>
                  <option value="b_name">작성자</option>
               </select>
               <input type="text" name="keyword" id="keyword" value="검색어를 입력하세요" class="form-control" />
               <button type="button" id="searchData" class="btn btn-success">검색</button>
            </div>
         </form>
      </div>
      
      <%--============================= 검색 기능 종료 =============================== --%>
      
      <%-- ===============================리스트 시작 ============================= --%>
      <div id="boardList" class="table-height">
         <table summary="게시판 리스트" class="table table-striped">
            <thead>
               <tr>
                  <th data-value = "b_num" class="order text-center col-md-1">글번호</th>
                  <th class="text-center col-md-6">글제목</th>
                  <th class="text-center col-md-2">작성자</th>
                  <th data-value = "d_date" class="text-center order-md-1">날짜</th>
                  <th class="text-center col-md-1">조회수</th>
               </tr>
            </thead>
            <tbody id="list" class="table-striped" >
               <!-- 데이터 출력 -->
               <c:choose>
                  <c:when test="${not empty boardList}">
                     <c:forEach var="board" items="${boardList}" varStatus="status">
                        <tr class="text-center" data-num="${board.b_num}">
                           <td>${board.b_num}</td>
                           <td class="goDetail text-left">${board.b_title}</td>
                           <td class="name">${board.b_name}</td>
                           <td class="text-center">${board.b_date}</td>                           
                           <td class="text-center">${board.readcnt}</td>
                        </tr>
                     </c:forEach>   
                  </c:when>
                  <c:otherwise>
                     <tr>
                        <td colspan="5" class="tac text-center">등록된 게시글이 존재하지 않습니다.</td> 
                     </tr>
                  </c:otherwise>
               </c:choose>
            </tbody>
         </table>      
      </div>
      <%-- ===========================================리스트 종료============================================= --%>
	<%--============================================ 페이징 출력 시작 ======================================= --%>
      <div class="text-center">
         <ul class="pagination">
            <!-- 이전 바로가기 10개 존재 여부를 prev 필드의 값으로 확인 -->
            <c:if test="${pageMaker.prev}">
               <li class="paginate_button previous">
                  <a href="${pageMaker.startPage -1 }">Previous</a>
               </li>
            </c:if>
            
            <!-- 바로가기 번호 출력 -->
            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
               <li class="paginate_button ${pageMaker.cvo.pageNum == num ? 'active':'' }">
                  <a href="${num}">${num}</a>
               </li>
            </c:forEach>
            
            <!-- 다음 바로가기 10개 존재 여부를 next 필드의 값으로 확인 -->
            <c:if test="${pageMaker.next}">
               <li class="paginate_button next">
                  <a href="${pageMaker.endPage + 1 }">Next</a>
               </li>
            </c:if>
         </ul>
      </div>   
      
      <%-- ===========================================페이징 출력 종료============================================= --%>
      
      
      
      
      
      <%-- ======================================  글쓰기 버튼 출력 시작  ====================================== --%>
      <div class="contentBtn text-right" >
         <input type="button" value="글쓰기"  id="insertFormBtn" class="btn btn-success"/>
      </div>
      <%-- ======================================  글쓰기 버튼 출력 종료  ====================================== --%>
   
   
      
   
   </div>
</body>
</html>