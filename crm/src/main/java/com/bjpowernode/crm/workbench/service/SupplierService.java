package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVO;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Supplier;

import java.util.List;
import java.util.Map;

public interface SupplierService {

    List<Supplier> getSupplierList();

    PaginationVO<Supplier> pageList(Map<String, Object> map);

    boolean addSupplier(Supplier supplier);

    Supplier getSupplier(String id);

    boolean updateSupplier(Supplier supplier);

    boolean deleteSupplier(String[] id);

    Supplier getDetail(String id);

    Map<String, Object> updateSupplierInDetail(Supplier supplier);
}
