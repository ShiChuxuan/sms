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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

	/*以上都为动画效果*/
		//日历控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		//为修改按钮绑定事件
		$("#editBtn").click(function () {
			//铺数据
			$.ajax({
				url:"workbench/Order/getUserListAndOrder.do",
				type:"get",
				data:{
					id:"${requestScope.order.id}"
				},
				dataType:"json",
				success(result){

					//处理所有者下拉框
					var html = '<option></option>'
					$.each(result.userList,function (i,n) {
						html+='<option value="'+n.id+'">'+n.name+'</option>'
					})
					$("#edit-owner").html(html);
					$("#edit-owner").val(result.order.owner);
					//处理其他的
					$("#edit-company").val(result.order.company);
					$("#edit-appellation").val(result.order.appellation);
					$("#edit-fullname").val(result.order.fullname);
					$("#edit-job").val(result.order.job);
					$("#edit-email").val(result.order.email);
					$("#edit-phone").val(result.order.phone);
					$("#edit-website").val(result.order.website);
					$("#edit-mphone").val(result.order.mphone);
					$("#edit-state").val(result.order.state);
					$("#edit-source").val(result.order.source);
					$("#edit-description").val(result.order.description);
					$("#edit-contactSummary").val(result.order.contactSummary);
					$("#edit-nextContactTime").val(result.order.nextContactTime);
					$("#edit-address").val(result.order.address);
					$("#editOrderModal").modal("show");

				}
			})
			$("#editOrderModal").modal("show");

		})


		//为更新按钮绑定事件
		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/Order/updateOrderInDetail.do",
				type:"get",
				data:{
					id:"${requestScope.order.id}",
					owner:$("#edit-owner").val(),
					company:$("#edit-company").val(),
					appellation:$("#edit-appellation").val(),
					fullname:$("#edit-fullname").val(),
					job:$("#edit-job").val(),
					email:$("#edit-email").val(),
					phone:$("#edit-phone").val(),
					website:$("#edit-website").val(),
					mphone:$("#edit-mphone").val(),
					state:$("#edit-state").val(),
					source:$("#edit-source").val(),
					description:$("#edit-description").val(),
					contactSummary:$("#edit-contactSummary").val(),
					nextContactTime:$("#edit-nextContactTime").val(),
					address:$("#edit-address").val()
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("更新成功！");
						//处理页面
						$("#DBT").text(result.order.fullname);
						$("#XBT").text(result.order.company);
						$("#MC").text(result.order.fullname);
						$("#SYZ").text(result.order.owner);
						$("#GS").text(result.order.company);
						$("#ZW").text(result.order.job);
						$("#YX").text(result.order.email);
						$("#GSZJ").text(result.order.phone);
						$("#GSWZ").text(result.order.website);
						$("#SJ").text(result.order.mphone);
						$("#DDZT").text(result.order.state);
						$("#XSLY").text(result.order.source);
						$("#CJZ").text(result.order.createBy);
						$("#CJSJ").text(result.order.createTime);
						$("#XGZ").text(result.order.editBy);
						$("#XGSJ").text(result.order.editTime);
						$("#MS").text(result.order.description);
						$("#LXJY").text(result.order.contactSummary);
						$("#XCLXSJ").text(result.order.nextContactTime);
						$("#XXDZ").text(result.order.address);

						$("#editOrderModal").modal("hide");
					}else{
						alert("更新失败！");
					}
				}
			})

		})


		//为删除按钮绑定事件
		$("#deleteBtn").click(function(){
			if(confirm("确认要删除所选的商品吗？")){

				$.ajax({
					url:"workbench/Order/deleteOrder.do",
					type:"get",
					data:{
						id:"${requestScope.order.id}"
					},
					dataType:"json",
					success(result){
						if(result.success){
							alert("删除成功");
							location.href='workbench/clue/index.jsp';
						}else{
							alert("删除失败");
						}
					}

				})
			}


		})

		//显示修改和删除备注的图标
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//铺备注数据
		showRemarkList();

		//为保存按钮添加时间
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/Order/addRemark.do",
				type:"get",
				data:{
					noteContent:$("#remark").val(),
					orderId:"${requestScope.order.id}"
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("添加成功");
						var html="";
						html+='<div id="'+result.remark.id+'" class="remarkDiv" style="height: 60px;">';
						html+='<img title="'+result.remark.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html+='<div style="position: relative; top: -40px; left: 40px;" >';
						html+='<h5 id="e'+result.remark.id+'">'+result.remark.noteContent+'</h5>';
						html+='<font color="gray">订单</font> <font color="gray">-</font> <b>${requestScope.good.name}</b> <small style="color: gray;" id="s'+result.remark.id+'"> '+result.remark.createTime+' 由 '+result.remark.createBy+'</small>'
						html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html+='<a class="myHref" href="javascript:void(0);" onclick="updateRemark(\''+result.remark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color:blue;"></span></a>';
						html+='&nbsp;&nbsp;&nbsp;&nbsp;';
						html+='<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+result.remark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color:red;"></span></a>';
						html+='</div>';
						html+='</div>';
						html+='</div>';
						$("#remarkDiv").before(html);
						$("#remark").val("");
					}else{
						alert("添加失败")
					}
				}
			})
		})


		//为更新备注按钮添加事件
		$("#updateRemarkBtn").click(function () {
			var id = $("#remarkId").val()
			$.ajax({
				url:"workbench/Order/updateRemark.do",
				type:"get",
				data:{
					id:id,
					noteContent:$.trim($("#noteContent").val())
				},
				dataType:"json",
				success(result){
					if(result.success==true){
						//修改备注成功后
						//修改div中相应的信息，需要更新的内容有noteContent,editTime,editBy
						$("#e"+id).html(result.remark.noteContent);
						$("#s"+id).html(result.remark.editTime+' 由 '+result.remark.editBy);
						$("#editOrderRemarkModal").modal("hide");

					}else{
						alert("修改备注失败");
					}
				}
			})
			$("#noteContent").val("");
			$("#editRemarkModal").modal("hide");
		})

		//展现关联商品列表
		showGoodList();

		//关联商品组件绑定事件
		$("#relate").click(function () {
			$.ajax({
				url:"workbench/Order/getGoodListByNameAndNotByOrderId",
				type:"get",
				data:{
					name:$("#search-name").val(),
					orderId:"${requestScope.order.id}"
				},
				dataType:"json",
				success(result){
					var html = "";
					$.each(result,function (i,n) {
						html+='<tr>';
						html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html+='<td>'+n.name+'</td>'
						html+='<td>'+n.sid+'</td>';
						html+='<td>'+n.price+'</td>';
						html+='<td>'+n.amount+'</td>';
						html+='</tr>';
					})
					$("#searchBody").html(html);
					$("#bundModal").modal("show");
				}
			})
			return false;
		})


		//为搜索框绑定事件
		$("#search-name").keydown(function (event) {
			if(event.keyCode==13){
				$.ajax({
					url:"workbench/Order/getGoodListByNameAndNotByOrderId",
					type:"get",
					data:{
						name:$("#search-name").val(),
						orderId:"${requestScope.order.id}"
					},
					dataType:"json",
					success(result){
						var html = "";
						$.each(result,function (i,n) {
							html+='<tr>';
							html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
							html+='<td>'+n.name+'</td>'
							html+='<td>'+n.sid+'</td>';
							html+='<td>'+n.price+'</td>';
							html+='<td>'+n.amount+'</td>';
							html+='</tr>';
						})
						$("#searchBody").html(html)
					}
				})
				//展现完列表一户，记得将模态窗口的默认回车事件禁用
				return false;
			}
		})

		//全选和全不选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		//动态生成的元素绑定事件:$(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		$("#searchBody").on("click",$("input[name=xz]"),function () {
			if($("input[name=xz]:checked").length==$("input[name=xz]").length){
				$("#qx").prop("checked",true);
			}else{
				$("#qx").prop("checked",false);
			}
		})


		//关联商品
		$("#relateBtn").click(function () {
			var $xz= $("input[name=xz]:checked");
			var param = "";
			$.each($xz,function (i,n) {
				param +="id=" +$(n).val();

				if(i<$xz.length-1){
					param +="&";
				}
			})
			param+="&orderId="+"${requestScope.order.id}"
			$.ajax({
				url:"workbench/Order/relate.do",
				type:"get",
				data:param,
				dataType:"json",
				success(result){
					if(result.success){
						alert("关联成功");
						showGoodList();
						$("#bundModal").modal("hide");
					}else{
						alert("关联失败");
					}
				}
			})
		})


	});

	function showRemarkList() {
		$.ajax({
			url:"workbench/Order/showRemarkList.do",
			type:"get",
			data:{
				orderId:"${requestScope.order.id}"
			},
			dataType: "json",
			success(result) {

				var html = "";
				$.each(result,function (i,n) {

					html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
					html+='<img title="'+n.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					html+='<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
					html+='<font color="gray">订单</font> <font color="gray">-</font> <b>${requestScope.order.fullname}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由 '+(n.editFlag==0? n.createBy:n.editBy)+'</small>'
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='<a class="myHref" href="javascript:void(0);" onclick="updateRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color:blue;"></span></a>';
					html+='&nbsp;&nbsp;&nbsp;&nbsp;';
					html+='<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color:red;"></span></a>';
					html+='</div>';
					html+='</div>';
					html+='</div>';

				})
				$("#remarkDiv").before(html);
			}

		})
	}

	//打开修改备注模态窗口铺数据
	function updateRemark(id) {
		$("#remarkId").val(id);
		$("#noteContent").val($("#e"+id).text());
		$("#editOrderRemarkModal").modal("show");
	}

	//删除备注
	function deleteRemark(id) {
		$.ajax({
			url:"workbench/Order/deleteRemark.do",
			type:"get",
			data:{
				id:id
			},
			dataType:"json",
			success(result){
				if(result.success){
					//如果成功，刷新备注列表
					//这种做法不行，因为用的是before(),不是html(),不会清空前面有的内容
					//showRemarkList();

					//找到需要删除记录的div，将div移除掉
					alert("删除成功");
					$("#"+id).remove();
				}else{
					alert("删除失败");
				}
			}
		})

	}

	//展现关联商品活动列表
	function showGoodList() {
		$.ajax({
			url:"workbench/Order/getGoodListByOrderId.do",
			type:"get",
			data:{
				orderId:"${requestScope.order.id}"
			},
			dataType:"json",
			success(result){
				var html = "";
				$.each(result,function (i,n) {
					html+='<tr>';
					html+='<td>'+n.name+'</td>';
					html+='<td>'+n.sid+'</td>';
					html+='<td>'+n.price+'</td>';
					html+='<td>'+n.amount+'</td>';
					html+='<td><a href="javascript:void(0);" onclick="unbund(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html+='</tr>';
				})
				$("#goodBody").html(html)
			}
		})
	}

	//解除关联
	function unbund(id) {
		$.ajax({
			url:"workbench/Order/unbund.do",
			type:"get",
			data:{
				id:id
			},
			dataType:"json",
			success(result){
				if(result.success){
					showGoodList();
				}else{
					alert("解除失败！");
				}
			}
		})
	}




</script>

</head>
<body>

	<!-- 关联商品的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联商品</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="search-name" placeholder="请输入商品名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="qx"/></td>
								<td>名称</td>
								<td>供应商</td>
								<td>售价</td>
								<td>库存</td>
							</tr>
						</thead>
						<tbody id="searchBody">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="relateBtn">关联</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改订单的模态窗口 -->
	<div class="modal fade" id="editOrderModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改订单</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
									<%--所有者--%>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<option></option>
									<c:forEach items="${appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" >
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">订单状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
									<option></option>
									<c:forEach items="${clueState}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">订单来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<option></option>
									<c:forEach items="${source}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" readonly>
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
								<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="1" id="edit-address"></textarea>
								</div>
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

	<!-- 修改订单备注的模态窗口 -->
	<div class="modal fade" id="editOrderRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>





	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="DBT">${requestScope.order.fullname} <small id="XBT">${requestScope.order.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?id=${requestScope.order.id}&company=${requestScope.order.company}&fullname=${requestScope.order.fullname}&appellation=${requestScope.order.appellation}&owner=${requestScope.order.owner}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="MC">${requestScope.order.fullname}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="SYZ">${requestScope.order.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="GS">${requestScope.order.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="ZW">${requestScope.order.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="YX">${requestScope.order.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="GSZJ">${requestScope.order.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="GSWZ">${requestScope.order.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="SJ">${requestScope.order.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">订单状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="DDZT">${requestScope.order.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="XSLY">${requestScope.order.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="CJZ">${requestScope.order.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="CJSJ">${requestScope.order.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="XGZ">${requestScope.order.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="XGSJ">${requestScope.order.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="MS">
					${requestScope.order.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="LXJY">
					${requestScope.order.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="XCLXSJ">${requestScope.order.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="XXDZ">
					${requestScope.order.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		

		

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button"  id="saveBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 订购商品 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>订购商品</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>供应商</td>
							<td>售价</td>
							<td>库存</td>
						</tr>
					</thead>
					<tbody id="goodBody">
						<%--<tr>
							<td>辛普劳1111</td>
							<td>麦肯食品(哈尔滨)有限公司</td>
							<td>11.11</td>
							<td>1000</td>
							<td>100</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>辛普劳222</td>
							<td>麦肯食品(哈尔滨)有限公司</td>
							<td>22.22</td>
							<td>2000</td>
							<td>200</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="relate" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联商品</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>