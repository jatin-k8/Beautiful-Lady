BEAUTIFUL LADY — RESPONSIVE WEBSITE + OWNER EDITING

FILES
- index.html: GitHub Pages home page (same customer storefront as customer.html)
- customer.html: customer storefront
- owner.html: private owner dashboard
- config.js: Supabase connection settings (KEEP YOUR OWN WORKING FILE)
- supabase_update.sql: updated database category constraint + homepage JSON settings
- assets/: model photos used by the homepage and category cards

MOBILE RESPONSIVE
The storefront now adapts to phone and tablet widths:
- Header and navigation become compact and horizontally scrollable.
- Hero copy appears above the three-photo collage on phones.
- Price and category cards use two columns.
- Product cards use two columns.
- Product detail modal and enquiry bag fit phone screens.

OWNER EDITING IN SUPABASE
Sign in at owner.html using your Supabase Auth owner email/password.
The Owner Studio lets you manage:
- Products: name, category, price, original price, tag, sizes/stock, description, visibility and up to 5 photos.
- Homepage: announcement, hero heading, subtitle and logo URL.
- Hero collage: upload replacement images for each of 3 collage slides (3 photos per slide).
- Shop by Price: labels, amount, captions and filter ranges.
- Shop by Category: all 6 category names, captions and images.
- Curated collections: titles, descriptions and images.
- Shop by Occasion: names, descriptions and images.
- Our Story: heading, text and photo.
- Boutique Standards: title and description.
- Instagram URL, shop address and Google Maps URL.
- WhatsApp number in Store Settings.
Trending Now and New Arrivals are generated from your product catalogue: use the product tag “Trending” for Trending Now; newest products appear in New Arrivals.

IMPORTANT SUPABASE STEPS
1. Keep your existing config.js with your real Supabase Project URL and publishable/anon key. Do not replace it with the placeholder config.js in this package.
2. In Supabase > SQL Editor, run the updated supabase_update.sql once. This updates the allowed product categories and ensures homepage_content exists. It does not delete products.
3. Ensure the Supabase Storage bucket named product-images exists and is public, and that your existing owner upload policies permit authenticated owner uploads.
4. Upload index.html, customer.html, owner.html, your own config.js, and the complete assets folder to the GitHub repository.
5. Do not publish private service_role keys. The browser must use only the publishable/anon key; owner writes must be protected by RLS/admin policies.

VIEW ON A PHONE
After GitHub Pages is enabled, open your published GitHub Pages URL on your phone. For a quick computer preview in Microsoft Edge, open the site, press Ctrl+Shift+I, then Ctrl+Shift+M, and choose a phone model from the device toolbar.
