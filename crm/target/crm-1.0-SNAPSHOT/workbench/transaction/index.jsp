<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
<meta charset="UTF-8">
<base href="<%=basePath%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript">

	$(function(){
		//日历控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});


		$("#search-btn").click(function(){
			//将搜索框中的内容赋给隐藏域
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-customer").val($.trim($("#search-customer").val()));
			$("#hidden-stage").val($.trim($("#search-stage").val()));
			$("#hidden-type").val($.trim($("#search-type").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-contacts").val($.trim($("#search-contacts").val()));
			pageList(1,2);

		})

		//全选全不选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		//动态生成的元素绑定事件:$(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		$("#tBody").on("click",$("input[name=xz]"),function () {
			if($("input[name=xz]:checked").length==$("input[name=xz]").length){
				$("#qx").prop("checked",true);
			}else{
				$("#qx").prop("checked",false);
			}
		})

		//为修改按钮绑定事件
		$("#editBtn").click(function(){
			if($("input[name=xz]:checked").length==0){
				alert("至少选择一个交易进行修改");
				return;
			}
			if($("input[name=xz]:checked").length>1){
				alert("每次修改不能超过一个交易");
				return;
			}
			location.href="workbench/Tran/getUserListAndTran.do?id="+$("input[name=xz]:checked").val()
		})

		//为删除按钮绑定事件
		$("#deleteBtn").click(function () {
			if($("input[name=xz]:checked").length==0){
				alert("至少选择一个交易进行删除");
				return;
			}
			$xz = $("input[name=xz]:checked")
			if(confirm("确认删除所选交易吗？")){
				var param = ''
				$.each($xz,function (i,n) {
					param+= 'id='+$(n).val()
					if(i<$xz.length-1){
						param+='&'
					}
				})
				$.ajax({
					url:"workbench/Tran/deleteTran.do",
					type:"post",
					data:param,
					dataType:"json",
					success(result){
						if(result.success){
							alert("删除成功！");
							pageList(1,$("#tranPage").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							alert("删除失败！");
						}
					}
				})
			}
		})

		pageList(1,2);
	});

	function pageList(pageNo,pageSize) {

		//去掉全选框的√
		$("#qx").prop("checked",false);

		//将隐藏域中的内容重新赋值给搜索框
		$("#search-owner").val($("#hidden-owner").val());
		$("#search-name").val($("#hidden-name").val());
		$("#search-customer").val($("#hidden-customer").val());
		$("#search-stage").val($("#hidden-stage").val());
		$("#search-type").val($("#hidden-type").val());
		$("#search-source").val($("#hidden-source").val());
		$("#search-contacts").val($("#hidden-contacts").val());

		$.ajax({
			url:"workbench/Tran/pageList.do",
			type:"get",
			data:{
				owner:$("#search-owner").val(),
				name:$("#search-name").val(),
				owner:$("#search-owner").val(),
				customer:$("#search-customer").val(),
				stage:$("#search-stage").val(),
				type:$("#search-type").val(),
				source:$("#search-source").val(),
				stage:$("#search-stage").val(),
				contacts:$("#search-contacts").val(),

				pageNo:pageNo,
				pageSize:pageSize

			},
			dataType:"json",
			success(result){
				var html = ''
				$.each(result.dataList,function (i,n) {
				    html+='<tr>'
					html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/Tran/getDetail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html+='<td>'+n.customerId+'</td>';
					html+='<td>'+n.stage+'</td>';
					html+='<td>'+n.type+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td>'+n.source+'</td>';
					html+='<td>'+n.contactsId+'</td>';
					html+='</tr>'
				})
				$("#tBody").html(html);

				//总页数
				var totalPages = Math.ceil(result.total/pageSize);

				//数据处理完毕后，结合分页查询，对前端展现分页信息
				$("#tranPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: result.total, // 总记录条数

					visiblePageLinks: 5, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					//该回调函数是在，点击分页组件的时候触发的
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}
		})

	}
	
</script>
</head>
<body>
	<input type="hidden" id="hidden-owner" >
	<input type="hidden" id="hidden-name" >
	<input type="hidden" id="hidden-customer" >
	<input type="hidden" id="hidden-stage" >
	<input type="hidden" id="hidden-type" >
	<input type="hidden" id="hidden-source" >
	<input type="hidden" id="hidden-contacts" >

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="search-owner" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="search-name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" id="search-customer" type="text">
				    </div>
				  </div>

				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
					  	<option></option>
						<c:forEach items="${stage}" var="a">
							<option value="${a.value}">${a.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-type">
					  	<option></option>
					  	<option value="已有业务">已有业务</option>
					  	<option value="新业务">新业务</option>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${source}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" id="search-contacts" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="search-btn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/save.jsp';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"  id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
							<td>动力节点</td>
							<td>谈判/复审</td>
							<td>新业务</td>
							<td>zhangsan</td>
							<td>广告</td>
							<td>李四</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
                            <td>动力节点</td>
                            <td>谈判/复审</td>
                            <td>新业务</td>
                            <td>zhangsan</td>
                            <td>广告</td>
                            <td>李四</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>

			<div style="height: 50px; position: relative;top: 10px;">

				<div id="tranPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>