package kr.or.ddit.edApproval.fancytree;

import kr.or.ddit.employee.vo.EmployeeVO;

public class EmployeeFancyTreeNode2 extends FancyTreeNodeAdapter<EmployeeVO> {

    public EmployeeFancyTreeNode2(EmployeeVO data) {
        super(data);
    }

    @Override
    public String getTitle() {
//        return getData().getEmpName();
        return getData().getEmpPosition();
    }

    @Override
    public String getKey() {
        return getData().getEmpCd();
    }

    @Override
    public boolean isFolder() {
        return false; // Employee는 자식노드 역할
    }
}




