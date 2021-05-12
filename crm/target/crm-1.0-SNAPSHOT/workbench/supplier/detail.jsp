<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
		/*以上都是动画效果*/

        $("#editBtn").click(function () {

            $.ajax({
                url:"workbench/Supplier/getSupplier.do",
                type:"get",
                data:{
                    id:"${requestScope.supplier.id}"
                },
                dataType:"json",
                success(result){
                    //处理其他信息
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
                url:"workbench/Supplier/updateSupplierInDetail.do",
                type:"get",
                data:{
                    id:"${requestScope.supplier.id}",
                    owner:$("#edit-owner").val(),
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
                        //更新页面
                        $("#DBT").text(result.supplier.name);
                        $("#WZ").text(result.supplier.website);
                        $("#MC").text(result.supplier.name);
                        $("#GYSWZ").text(result.supplier.website);
                        $("#LXDH").text(result.supplier.phone);
                        $("#CJZ").text(result.supplier.createBy);
                        $("#CJSJ").text(result.supplier.createTime);
                        $("#XGZ").text(result.supplier.editBy);
                        $("#XGSJ").text(result.supplier.editTime);
                        $("#MS").text(result.supplier.description)
                        $("#XXDZ").text(result.supplier.address);

                        $("#editSupplierModal").modal("hide");
                    }else{
                        alert("更新失败");
                    }
                }
            })
        })

        $("#deleteBtn").click(function () {
            if(confirm("确认删除该供应商吗？")){
                $.ajax({
                    url:"workbench/Supplier/deleteSupplier.do",
                    type:"post",
                    data:{
                        id:"${requestScope.supplier.id}"
                    },
                    dataType:"json",
                    success(result){
                        if(result.success){
                            alert("删除成功！");
                            location.href="workbench/supplier/index.jsp";
                        }else{
                            alert("删除失败！");
                        }
                    }
                })
            }
        })

	});




</script>

</head>
<body>



    <!-- 修改赞助商的模态窗口 -->
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="DBT">${requestScope.supplier.name} </h3><small><a href="${requestScope.supplier.website}" target="_blank" id="WZ">${requestScope.supplier.website}</a></small>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<br>
	<br>
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px;position: relative; color: gray; top: -10px;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -30px;"><b id="MC">${requestScope.supplier.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -30px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">供应商网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="GYSWZ">${requestScope.supplier.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">联系电话</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="LXDH">${requestScope.supplier.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="CJZ">${requestScope.supplier.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="CJSJ">${requestScope.supplier.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="XGZ">${requestScope.supplier.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="XGSJ">${requestScope.supplier.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="MS">
					${requestScope.supplier.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<br>
		<br>
		<br>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="XXDZ">
					${requestScope.supplier.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>


	<div style="height: 200px;"></div>
</body>
</html>