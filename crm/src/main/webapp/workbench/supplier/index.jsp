<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//为查询按钮绑定事件
		$("#search-Btn").click(function () {
			//把搜索框的内容给隐藏域
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-phone").val($.trim($("#search-phone").val()));
			$("#hidden-website").val($.trim($("#search-website").val()));
			pageList(1,2);
		})

		//为保存按钮绑定事件
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/Supplier/addSupplier.do",
				type:"get",
				data:{
					name:$("#create-name").val(),
					website:$("#create-website").val(),
					phone:$("#create-phone").val(),
					description:$("#create-description").val(),
					address:$("#create-address").val()
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("添加成功！");
						pageList(1,$("#supplierPage").bs_pagination('getOption', 'rowsPerPage'));
						var addSupplierForm = $("#addSupplierForm")[0];
						addSupplierForm.reset();
						$("#createSupplierModal").modal("hide");
					}else{
						alert("添加失败！");
					}
				}
			})
		})

		//全选与全不选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		$("#tBody").on("click",$("input[name=xz]"),function () {
			if($("input[name=xz]:checked").length==$("input[name=xz]").length){
				$("#qx").prop("checked",true);
			}else{
				$("#qx").prop("checked",false);
			}
		})

		//为修改按钮绑定事件
		$("#editBtn").click(function () {
			if($("input[name=xz]:checked").length==0){
				alert("至少选择一个供应商进行修改");
				return;
			}
			if($("input[name=xz]:checked").length>1){
				alert("每次修改不能超过一个供应商");
				return;
			}
			$.ajax({
				url:"workbench/Supplier/getSupplier.do",
				type:"get",
				data:{
					id:$("input[name=xz]:checked").val()
				},
				dataType:"json",
				success(result){

					$("#edit-name").val(result.name);
					$("#edit-website").val(result.website);
					$("#edit-phone").val(result.phone);
					$("#edit-description").val(result.description);
					$("#edit-address").val(result.address);

					$("#editSupplierModal").modal("show");
				}
			})
		})

		$("#updateBtn").click(function(){
			$.ajax({
				url:"workbench/Supplier/updateSupplier.do",
				type:"get",
				data:{
					id:$("input[name=xz]:checked").val(),
					name:$("#edit-name").val(),
					website:$("#edit-website").val(),
					phone:$("#edit-phone").val(),
					description:$("#edit-description").val(),
					address:$("#edit-address").val()
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("更新成功");
						pageList($("#supplierPage").bs_pagination('getOption', 'currentPage'),
								$("#supplierPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editSupplierModal").modal("hide");
					}else{
						alert("更新失败");
					}
				}
			})
		})

		//为删除按钮绑定事件
		$("#deleteBtn").click(function () {
			if($("input[name=xz]:checked").length==0){
				alert("至少选择一个供应商进行删除");
				return;
			}
			$xz = $("input[name=xz]:checked")
			if(confirm("确认删除所选供应商吗？")){
				var param = ''
				$.each($xz,function (i,n) {
					param+= 'id='+$(n).val()
					if(i<$xz.length-1){
						param+='&'
					}
				})
				$.ajax({
					url:"workbench/Supplier/deleteSupplier.do",
					type:"post",
					data:param,
					dataType:"json",
					success(result){
						if(result.success){
							alert("删除成功！");
							pageList(1,$("#supplierPage").bs_pagination('getOption', 'rowsPerPage'));
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

		$("#search-name").val($("#hidden-name").val());
		$("#search-phone").val($("#hidden-phone").val());
		$("#search-website").val($("#hidden-website").val());

		var name = $("#search-name").val();
		var phone = $("#search-phone").val();
		var website = $("#search-website").val();


		$.ajax({
			url:"workbench/Supplier/pageList.do",
			type:"get",
			data: {
				pageNo:pageNo,
				pageSize:pageSize,
				name:name,
				phone:phone,
				website:website

			},

			dataType:"json",
			success(result){

				var html = '';
				$.each(result.dataList,function (i,n) {
					html+='<tr>';
					html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/Supplier/getDetail.do?id='+n.id+'\';">'+n.name+'</a></td>';
					html+='<td>'+n.phone+'</td>'
					html+='<td>'+n.website+'</td>'
					html+='</tr>';
				})
				$("#tBody").html(html);

				//总页数
				var totalPages = Math.ceil(result.total/pageSize);

				//数据处理完毕后，结合分页查询，对前端展现分页信息
				$("#supplierPage").bs_pagination({
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

<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-phone">
<input type="hidden" id="hidden-website">



	<!-- 创建供应商的模态窗口 -->
	<div class="modal fade" id="createSupplierModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建供应商</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="addSupplierForm">
					
						<div class="form-group">
							<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>

							<label for="create-website" class="col-sm-2 control-label">供应商网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">联系电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editSupplierModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改供应商</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" >
							</div>
							<label for="edit-website" class="col-sm-2 control-label">供应商网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">联系电话</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>


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
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>供应商列表</h3>
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
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  

				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">供货商座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">供货商网站</div>
				      <input class="form-control" type="text" id="search-website">
				    </div>
				  </div>
				  
				  <button type="button" id="search-Btn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createSupplierModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/supplier/detail.jsp';">隔壁的供货商111</a></td>
							<td>010-13246781</td>
							<td>http://www.gebisupplier111.com</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/supplier/detail.jsp';">隔壁的供货商222</a></td>
                            <td>010-65498791</td>
                            <td>http://www.gebisupplier222com</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
				<div id="supplierPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>