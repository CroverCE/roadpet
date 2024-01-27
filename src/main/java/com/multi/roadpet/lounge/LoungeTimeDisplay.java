package com.multi.roadpet.lounge;

import java.text.SimpleDateFormat;
import java.util.Date;

public class LoungeTimeDisplay {
	
	private static class Time {
		public static final int sec = 60;
		public static final int min = 60;
		public static final int hour = 24;
		public static final int	day = 30;
		public static final int month = 12;
		public static final int year = 12;
	}
	
	public static String TimeCondition(Date date) {
		long timeNow = System.currentTimeMillis();
		long insTime = date.getTime();
		long difTime = (timeNow - insTime) / 1000;
		String displayTime = null;
		if (difTime < Time.sec) {
			displayTime = "��� ��"; //60�� �̸�
		} else if ((difTime /= Time.sec) < Time.min) {
			displayTime = difTime + "�� ��"; //60�� �̸�
		} else if ((difTime /= Time.min) < Time.hour) {
			displayTime = (difTime) + "�ð� ��"; //24�ð� �̸�
		} else if ((difTime /= Time.hour) < Time.day) {
			displayTime = (difTime) + "�� ��"; //30�� �̸�
		} else if ((difTime /= Time.day) < Time.month) {
			displayTime = (difTime) + "�� ��"; //12���� �̸�
		} else if ((difTime /= Time.month) < Time.year) {
			displayTime = (difTime) + "�� ��"; //12�� �̸�
		} else {
			displayTime = "���� ��";
		}
		return displayTime;		
	}
	
	public String TimeFormat(Date lounge_date) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm");
		String insFormat = dateFormat.format(lounge_date);
		return insFormat;
	}
}