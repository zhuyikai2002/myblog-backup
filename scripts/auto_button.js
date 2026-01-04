// scripts/auto_button.js

hexo.extend.filter.register('before_post_render', function(data){
  
  // 首页链接按钮（不显示文字，仅保留功能）
  const homeBtn = `
<div class="geek-home-btn-container">
  <a href="/" class="geek-home-btn" title="返回首页"></a>
</div>
`;

  // 把按钮插到文章最前面
  data.content = homeBtn + data.content;
  return data;
});