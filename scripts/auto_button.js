// scripts/auto_button.js

hexo.extend.filter.register('before_post_render', function(data){
  
  // 这里的 HTML 变得非常短，不容易触发 Markdown 的代码块 bug
  // 我们保留了你喜欢的 < cd /home >
  const homeBtn = `
<div class="geek-home-btn-container">
  <a href="/" class="geek-home-btn">&lt; cd /home &gt;</a>
</div>
`;

  // 把按钮插到文章最前面
  data.content = homeBtn + data.content;
  return data;
});