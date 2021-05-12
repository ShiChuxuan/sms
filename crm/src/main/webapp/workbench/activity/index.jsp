<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js" charset="GBK"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js" charset="GBK"></script>
<script type="text/javascript">

	$(function(){
		//日历插件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		//填充搜索框的供应商下拉列表
		$.ajax({
			url:"workbench/Goods/supplierList.do",
			type:"get",
			data:{},
			dataType:"json",
			success(result){
				var html = "<option></option>"
				$.each(result,function (i,n) {
					html += "<option value='"+n.id+"'>"+n.name+"</option>"
				})
				$("#search-GoodSupplier").html(html);
			}
		})





		//为创建按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {

			$.ajax({
				url:"workbench/Goods/supplierList.do",
				type:"get",
				data:{},
				dataType:"json",
				success(result){
					var html = "<option></option>"
					$.each(result,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>"
					})
					$("#create-goodSupplier").html(html);
				}
			})

			$("#createGoodModal").modal("show");
		})

		//添加商品
		$("#saveBtn").click(function () {
			//清空错误信息
			$("#create-goodSupplierMsg").text("");
			$("#create-goodNameMsg").text("");

			if($("#create-goodSupplier").val()==""){
				$("#create-goodSupplierMsg").text("供应商为必填项");
				return;
			}
			if($("#create-goodName").val()==""){
				$("#create-goodNameMsg").text("商品名称为必填项");
				return;
			}

			//注意一下 $.trim()方法是去除开头和末尾的空格，不是去掉所有的空格
			$.ajax({
				url:"workbench/Goods/addGood.do",
				type: "post",
				data:{
					sid:$.trim($("#create-goodSupplier").val()) ,
					name:$.trim($("#create-goodName").val()),
					firstDate:$.trim($("#create-firstDate").val()),
					amount:$.trim($("#create-amount").val()),
					cost:$.trim($("#create-cost").val()),
					description:$.trim($("#create-description").val()),
				},
				dataType: "json",
				success(result) {
					if(result.success){
						var addGoodForm = $("#addGoodForm")[0]
						addGoodForm.reset();
						$("#createGoodModal").modal("hide");
						pageList(1,$("#goodsPage").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						alert("添加失败");
					}
				}
			})

		})

		//删除商品
		$("#deleteBtn").click(function () {
			var $xz= $("input[name=xz]:checked");

			if($xz.length==0){
				alert("至少选择一个商品进行删除");
				return;
			}else{
				if(confirm("确认要删除所选的商品吗？")){
					var param = "";
					$.each($xz,function (i,n) {
						param +="id=" +$(n).val();

						if(i<$xz.length-1){
							param +="&";
						}
					})
					$.ajax({
						url:"workbench/Goods/deleteGood.do",
						type:"get",
						data:param,
						dataType:"json",
						success(result){
							if(result.success){
								alert("删除成功");
								pageList(1,$("#goodsPage").bs_pagination('getOption', 'rowsPerPage'));
							}else{
								alert("删除失败");
							}
						}

					})
				}
			}

		})


		//修改商品
		$("#editBtn").click(function () {
			if($("input[name=xz]:checked").length==0){
				alert("至少选择一种商品进行修改");
				return;
			}
			if($("input[name=xz]:checked").length>1){
				alert("每次修改不能超过一种商品");
				return;
			}
			$.ajax({
				url:"workbench/Goods/getSupplierListAndGood.do",
				type:"get",
				data:{
					id:$("input[name=xz]:checked").val()
				},
				dataType:"json",
				success(result){
					//处理赞助商下拉框
					var html = '<option></option>'
					$.each(result.supplierList,function (i,n) {
						html+='<option value="'+n.id+'">'+n.name+'</option>'
					})
					$("#edit-goodSupplier").html(html);
					$("#edit-goodSupplier").val(result.good.sid);//默认选中

					//处理商品
					$("#edit-goodId").val(result.good.id);
					$("#edit-goodName").val(result.good.name);
					$("#edit-firstDate").val(result.good.firstDate);
					$("#edit-lastDate").val(result.good.lastDate);
					$("#edit-cost").val(result.good.cost);
					$("#edit-description").val(result.good.description);

				}
			})

			$("#editGoodModal").modal("show");
		})

		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/Goods/updateGood.do",
				type:"get",
				data:{
					id:$.trim($("#edit-goodId").val()),
					sid: $.trim($("#edit-goodSupplier").val()),
					name:$.trim($("#edit-goodName").val()),
					firstDate:$.trim($("#edit-firstDate").val()),
					lastDate:$.trim($("#edit-lastDate").val()),
					cost: $.trim($("#edit-cost").val()),
					description:$.trim($("#edit-description").val()),
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("更新成功！");
						pageList($("#goodsPage").bs_pagination('getOption', 'currentPage'),
								$("#goodsPage").bs_pagination('getOption', 'rowsPerPage'));
							$("#editGoodModal").modal("hide");
					}else{
						alert("更新失败！");
					}
				}
			})

		})



		//给查询按钮的添加方法
		$("#search-Btn").click(function () {
			//先把搜索框的内容赋给隐藏域
			$("#hidden-Name").val($.trim($("#search-Name").val()));
			$("#hidden-Supplier").val($.trim($("#search-GoodSupplier").val()));
			$("#hidden-FirstTime").val($.trim($("#search-FirstTime").val()));
			$("#hidden-LastTime").val($.trim($("#search-LastTime").val()));

			pageList(1,$("#goodsPage").bs_pagination('getOption', 'rowsPerPage'));
		})


		//全选和全不选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		//动态生成的元素绑定事件:$(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		$("#goodsBody").on("click",$("input[name=xz]"),function () {
			if($("input[name=xz]:checked").length==$("input[name=xz]").length){
				$("#qx").prop("checked",true);
			}else{
				$("#qx").prop("checked",false);
			}
		})


		//清空日期栏
		$("#search-FirstTime").click(function () {
			$("#search-FirstTime").val("");
		})
		$("#search-LastTime").click(function () {
			$("#search-LastTime").val("");
		})

		//页面加载完毕后触发一个方法
		pageList(1,2);
		
	});

	//页面刚加载完、添加修改删除、查询、点击分页插件的页码按钮的时候需要使用该方法 共六处
	function pageList(pageNo,pageSize) {

		//去掉全选框的√
		$("#qx").prop("checked",false);

		//查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框当中
		$("#search-Name").val($.trim($("#hidden-Name").val()))
		$("#search-GoodSupplier").val($.trim($("#hidden-Supplier").val()))
		$("#search-FirstTime").val($.trim($("#hidden-FirstTime").val()))
		$("#search-LastTime").val($.trim($("#hidden-LastTime").val()))



		$.ajax({
			url:"workbench/Goods/pageList.do",
			type:"get",
			data:{
				name:$.trim($("#hidden-Name").val()),
				supplier:$.trim($("#hidden-Supplier").val()),
				firstDate:$.trim($("#hidden-FirstTime").val()),
				lastDate:$.trim($("#hidden-LastTime").val()),
				pageNo:pageNo,
				pageSize:pageSize
			},
			dataType:"json",
			success(result){
				var html = "";
				$.each(result.dataList,function (i,n) {
				html+='<tr class="active">';
				html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
				html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/Goods/getDetail.do?id='+n.id+'\';">'+n.name+'</a></td>';
				html+='<td>'+n.sid+'</td>';
				html+='<td>'+n.firstDate+'</td>';
				html+='<td>'+n.lastDate+'</td>';
				html+='<td>'+n.cost+'</td>';
				html+='<td>'+n.amount+'</td>';
				html+='</tr>'

				})
				$("#goodsBody").html(html);

				//总页数
				var totalPages = Math.ceil(result.total/pageSize);


				//分页插件
				$("#goodsPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: result.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

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

	<!-- 创建商品的模态窗口 -->
	<div class="modal fade" id="createGoodModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建商品</h4>
				</div>
				<div class="modal-body">
				
					<form id="addGoodForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-goodSupplier" class="col-sm-2 control-label">供应商<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-goodSupplier">
								  <%--所有者、供应商列表--%>
								</select>
								<span id="create-goodSupplierMsg" style="color: red"></span>
							</div>
                            <label for="create-goodName" class="col-sm-2 control-label">商品名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-goodName">
								<span id="create-goodNameMsg" style="color: red"></span>
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-firstDate" class="col-sm-2 control-label">首次进货日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-firstDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">商品进价</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>

							<label for="create-cost" class="col-sm-2 control-label">商品数量</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-amount">
							</div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">商品描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveBtn" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改商品的模态窗口 -->
	<div class="modal fade" id="editGoodModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改商品</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-goodSupplier" class="col-sm-2 control-label">供应商<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-goodSupplier">
								  <%--修改模态窗口的供应商--%>
								</select>
							</div>
                            <label for="edit-goodName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-goodName">

								<input type="hidden" id="edit-goodId"> <%--商品id--%>
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-firstDate" class="col-sm-2 control-label">首次进货时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" readonly id="edit-firstDate">
							</div>
							<label for="edit-lastDate" class="col-sm-2 control-label">最新进货时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" readonly id="edit-lastDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>



	<input type="hidden" id="hidden-Name">
	<input type="hidden" id="hidden-Supplier">
	<input type="hidden" id="hidden-FirstTime">
	<input type="hidden" id="hidden-LastTime">


	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>商品列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search-Name" class="form-control" type="text">	<%--商品名字搜索框--%>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">供应商</div>
						<select class="form-control" id="search-GoodSupplier">	<%--供应商搜索框--%>
							<%--搜索框的供应商列表--%>
						</select>
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">首次进货日期</div>
					  <input  class="form-control time" type="text" id="search-FirstTime" readonly/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">最新进货日期</div>
					  <input  class="form-control time" type="text" id="search-LastTime" readonly>
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="search-Btn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">

					<%--创建、修改、删除按钮--%>
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>商品名称</td>
                            <td>供货商</td>
							<td>首次进货日期</td>
							<td>最新进货日期</td>
							<td>成本</td>
							<td>库存</td>
						</tr>
					</thead>
					<tbody id="goodsBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/activity/detail.jsp';">辛普劳 蓝带黄金1/4细薯条</a></td>
                            <td>辛普劳（中国）食品有限公司</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>11.00</td>
							<td>1000</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">麦肯 8/1细薯条</a></td>
							<td>麦肯（中国）食品有限公司</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>11.00</td>
							<td>1000</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div  style="height: 50px; position: relative;top: 30px;">
				<div id="goodsPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>