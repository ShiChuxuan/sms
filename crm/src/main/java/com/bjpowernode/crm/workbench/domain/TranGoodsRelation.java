package com.bjpowernode.crm.workbench.domain;

public class TranGoodsRelation {
    private String id;
    private String tranId;
    private String goodId;
    private String amount;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTranId() {
        return tranId;
    }

    public void setTranId(String tranId) {
        this.tranId = tranId;
    }

    public String getGoodId() {
        return goodId;
    }

    public void setGoodId(String goodId) {
        this.goodId = goodId;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    @Override
    public String toString() {
        return "TranGoodsRelation{" +
                "id='" + id + '\'' +
                ", tranId='" + tranId + '\'' +
                ", goodId='" + goodId + '\'' +
                ", amount='" + amount + '\'' +
                '}';
    }
}
