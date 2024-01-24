package com.multi.roadpet.pet;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PetWalkDAO {

	@Autowired
	SqlSessionTemplate my;
	
	public void insert(PetWalkVO petwalkVO) {
		my.insert("petWalk.insert",petwalkVO);
	}
	public PetWalkVO one(int pet_id) { //id=4
		return my.selectOne("petWalk.one", pet_id);	
	}
	public PetInfoVO one2(int pet_id) { //id=4
		return my.selectOne("petInfo.one", pet_id);	
	} //��å���������� ����, �̸� ��������
	
	public List<PetWalkVO> list(PetWalkVO petwalkVO) throws Exception { 
		List<PetWalkVO> list = my.selectList("petWalk.today_list",petwalkVO);	
		return list;
	} // ��¥�� ���� ��å ���� ��������
	
	public List<PetWalkVO> list2(PetWalkVO petwalkVO) throws Exception { 
		List<PetWalkVO> list2 = my.selectList("petWalk.week_list",petwalkVO);	
		return list2;
	} // ��¥�� ���� ��å ���� ��������
	public List<PetWalkVO> list3(PetWalkVO petwalkVO) throws Exception { 
		List<PetWalkVO> list3 = my.selectList("petWalk.all_week_list",petwalkVO);	
		return list3;
	} // ��¥��
}
