function normalizeText(text) {
  if (!text || text.trim() === "" || text === "(null)") {
    return "정보 없음";
  }

  // 문자열에 포함된 \\n → 실제 줄바꿈 문자로
  let fixed = text.replace(/\\n/g, "\n");

  // 줄바꿈이 여러 번 있을 때는 하나로 정리
  fixed = fixed.replace(/\n{2,}/g, "\n");

  // \n을 <br> 태그로 변환하여 HTML로 줄바꿈 반영
  fixed = fixed.replace(/\n/g, "<br>");

  return fixed.trim(); // 혹시 앞뒤 공백이 있을 경우 제거
}

console.log("Place Floor: ", place.floor);
console.log("Place Major: ", place.major);

// 기존 코드에 적용
document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("floor-info").innerHTML = normalizeText(place.floor);
    document.getElementById("major-info").innerHTML = normalizeText(place.major);
});

module.exports = normalizeText;
