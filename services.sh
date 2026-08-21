#!/bin/bash
# Google 服务清单：名称 | URL | 图标域名 | Bundle ID 后缀 | 备用图标 emoji | 备用图标背景色 | 官方图标 URL
# Google services: Name | URL | Icon domain | Bundle ID suffix | Fallback emoji | Fallback color | Official icon URL

SERVICES=(
  "Gmail|https://mail.google.com|mail.google.com|gmail|✉️|#EA4335|https://www.gstatic.com/images/branding/product/2x/gmail_2020q4_48dp.png"
  "Google Calendar|https://calendar.google.com|calendar.google.com|calendar|📅|#4285F4|https://www.gstatic.com/images/branding/product/2x/calendar_2020q4_48dp.png"
  "Google Drive|https://drive.google.com|drive.google.com|drive|📁|#34A853|https://www.gstatic.com/images/branding/product/2x/drive_2020q4_48dp.png"
  "Google Docs|https://docs.google.com/document/u/0/|docs.google.com|docs|📄|#4285F4|https://www.gstatic.com/images/branding/product/2x/docs_2020q4_48dp.png"
  "Google Sheets|https://docs.google.com/spreadsheets/u/0/|docs.google.com|sheets|📊|#34A853|https://www.gstatic.com/images/branding/product/2x/sheets_2020q4_48dp.png"
  "Google Slides|https://docs.google.com/presentation/u/0/|docs.google.com|slides|📽️|#FBBC04|https://www.gstatic.com/images/branding/product/2x/slides_2020q4_48dp.png"
  "Google Meet|https://meet.google.com|meet.google.com|meet|📹|#00897B|https://www.gstatic.com/images/branding/product/2x/meet_2020q4_48dp.png"
  "Google Photos|https://photos.google.com|photos.google.com|photos|🖼️|#FF7A00|https://www.gstatic.com/images/branding/product/2x/photos_64dp.png"
  "YouTube|https://www.youtube.com|youtube.com|youtube|▶️|#FF0000|https://www.gstatic.com/youtube/img/branding/favicon/favicon_144x144.png"
  "Google Maps|https://maps.google.com|maps.google.com|maps|🗺️|#1A73E8|https://www.gstatic.com/images/branding/product/2x/maps_64dp.png"
)

VERSION="2.1.0"
